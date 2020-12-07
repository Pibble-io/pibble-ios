//
//  MediaPostingInteractor.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 13.07.2018.
//Copyright © 2018 com.kazai. All rights reserved.
//

import Foundation
import Photos
import AVFoundation

// MARK: - MediaPostingInteractor Class
final class MediaPostingInteractor: Interactor {
  
  let postingDraft: MutablePostDraftProtocol

  var campaignDraft: CampaignDraftProtocol? {
    return postingDraft.campaignDraft
  }
  
  fileprivate let mediaLibraryExportService: MediaLibraryExportServiceProtocol
  fileprivate let createPostService: CreatePostServiceProtocol
  fileprivate let accountService: AccountProfileServiceProtocol
  
  fileprivate lazy var imageManager =  {
    return PHCachingImageManager()
  }()
  
  fileprivate lazy var imageRequestOptions: PHImageRequestOptions = {
    let opt = PHImageRequestOptions()
    opt.resizeMode = .fast
    opt.deliveryMode = .highQualityFormat
    opt.isNetworkAccessAllowed = true
    return opt
  }()
  
  init(mediaLibraryExportService: MediaLibraryExportServiceProtocol,
       createPostService: CreatePostServiceProtocol,
       accountService: AccountProfileServiceProtocol,
       postingDraft: MutablePostDraftProtocol) {
  
   
    self.mediaLibraryExportService = mediaLibraryExportService
    self.createPostService = createPostService
    self.accountService = accountService
    self.postingDraft = postingDraft
  }
}

// MARK: - MediaPostingInteractor API
extension MediaPostingInteractor: MediaPostingInteractorApi {
  var canBePosted: Bool {
    guard postingDraft.canBePosted else {
      return false
    }
    
    guard postingDraft.postingType == .commercial else {
      return true
    }
    
    guard let profile = accountService.currentUserAccount else {
      return false
    }
    
    guard let pickedPrice = postingDraft.commerceDraftAttributes.price else {
      return false
    }
    
    guard profile.digitalGoodPriceLimits.min.value.isLessThanOrEqualTo(pickedPrice),
      pickedPrice.isLessThanOrEqualTo(profile.digitalGoodPriceLimits.max.value)
    else {
      return false
    }
    
    return true
  }
  
  func initialFetchData() {
    accountService.getProfile { [weak self] in
      switch $0 {
      case .success:
        break
      case .failure(let error):
        self?.presenter.handleError(error)
      }
    }
  }
  
  func performPosting() {
    createPostService.performPosting(draft: postingDraft)
  }
  
  func beginPreUploadingTask() {
    createPostService.beginPreUploadingTask(draft: postingDraft)
  }
  
  func cancelPreUploadingTask() {
    createPostService.cancelPreUploadingTask(draft: postingDraft)
  }
  
  func numberOfMediaAttachmentSections() -> Int {
    return 1
  }
  
  func numberOfMediaAttachmentsInSection(_ section: Int) -> Int {
    return postingDraft.attachedMedia.count
  }
  
  func requestMediaAttachmentsPreviewFor(_ indexPath: IndexPath, config: ImageRequestConfig, result: @escaping ImageRequestResult) {
    
    let media = postingDraft.attachedMedia[indexPath.item]
    switch media {
    case .video(let videoAssetURL):
      let videoAsset = AVAsset(url: videoAssetURL)
      getVideoThumbnailForVideo(videoAsset) {
        result($0, indexPath)
      }
    case .image(let imageAsset):
      result(imageAsset.underlyingAsset, indexPath)
      return
    case .libraryMediaItem(let asset):
      imageManager.requestImage(for: asset.underlyingAsset, targetSize: config.size, contentMode: config.contentMode, options: imageRequestOptions) { [weak self] (image, _) in
        guard let image = image else {
          result(nil, indexPath)
          return
        }
        
        self?.mediaLibraryExportService.resizeImageWithCurrentExportSettings(image: image, cropPerCent: asset.crop) {
          result($0, indexPath)
        }
      }
    }
  }
  
  fileprivate func getVideoThumbnailForVideo(_ asset: AVAsset, complete: @escaping (UIImage?) -> Void) {
    DispatchQueue.global(qos: .utility).async {
      let imageGenerator = AVAssetImageGenerator(asset: asset)
      imageGenerator.appliesPreferredTrackTransform = true
      
      var time = asset.duration
      
      time.value = time.value / 2
      guard let imageRef = try? imageGenerator.copyCGImage(at: time, actualTime: nil) else {
        DispatchQueue.main.async {
           complete(nil)
        }
        return
      }
      
      let image = UIImage(cgImage: imageRef)
      
      DispatchQueue.main.async {
        complete(image)
      }
    }
  }
}

// MARK: - Interactor Viper Components Api
private extension MediaPostingInteractor {
    var presenter: MediaPostingPresenterApi {
        return _presenter as! MediaPostingPresenterApi
    }
}
