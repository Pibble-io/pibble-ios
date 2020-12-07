//
//  MediaPickInteractor.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 02.07.2018.
//Copyright © 2018 com.kazai. All rights reserved.
//

import Foundation
import Photos

// MARK: - MediaPickInteractor Class
final class MediaPickInteractor: Interactor {
  fileprivate let mediaLibraryExportService: MediaLibraryExportServiceProtocol
  fileprivate var currentMediaAlbum: MediaAlbumPick.Album = .none
  
  let config: MediaPick.Config
  
  fileprivate var assets: [PHFetchResult<PHAsset>] = []
  fileprivate lazy var imageManager = {
    return PHCachingImageManager()
  }()
  
  fileprivate lazy var imageRequestOptions: PHImageRequestOptions = {
    let opt = PHImageRequestOptions()
    opt.resizeMode = .fast
    opt.deliveryMode = .highQualityFormat
    opt.isNetworkAccessAllowed = true
    return opt
  }()
  
  init(mediaLibraryExportService: MediaLibraryExportServiceProtocol, config: MediaPick.Config) {
    self.mediaLibraryExportService = mediaLibraryExportService
    self.config = config
  }
}

// MARK: - MediaPickInteractor API
extension MediaPickInteractor: MediaPickInteractorApi {
  func checkIsItemAvailableAt(_ indexPath: IndexPath) -> Bool {
    let asset = assets[indexPath.section].object(at: indexPath.item)
    switch asset.mediaType {
    case .unknown:
      presenter.handleError(MediaPick.MediaPickError.unsupportedMediaType)
      return false
    case .image:
      return true
    case .video:
      let limit = mediaLibraryExportService.videoCaptureSettings.maxDurationTimeinterval
      let isShorterThanVideoLengthLimit = asset.duration.isLessThanOrEqualTo(limit)
      if !isShorterThanVideoLengthLimit {
        presenter.presentVideoLengthWarningForItemAt(indexPath, maxVideoLength: limit)
      }
      return true
    case .audio:
      presenter.handleError(MediaPick.MediaPickError.unsupportedMediaType)
      return false
    }
  }
  
  var currentPickedMediaAlbum: MediaAlbumPick.Album {
    return currentMediaAlbum
  }
  
  func setPickedMediaAlbum(_ album: MediaAlbumPick.Album) {
    currentMediaAlbum = album
    fetchData()
  }
  
  func itemAt(_ indexPath: IndexPath) -> PHAsset {
    let asset = assets[indexPath.section].object(at: indexPath.item)
    return asset
  }
  
  func durationForMediaAt(_ indexPath: IndexPath) -> TimeInterval? {
    let asset = assets[indexPath.section].object(at: indexPath.item)
    return asset.mediaType == .video ? asset.duration : nil
  }
  
  func dropCachedData() {
 
  }
  
  func requestImageFor(_ indexPath: IndexPath, config: ImageRequestConfig, result: @escaping ImageRequestWithProcessedResult) {
    
    requestMediaFor(indexPath, config: config, shouldRequestVideo: false) { (originalAspectImage, resizedImage, _, indexPath) in
      result(originalAspectImage, resizedImage, indexPath)
    }
  }
  
  func requestMediaFor(_ indexPath: IndexPath, config: ImageRequestConfig, result: @escaping MediaRequestWithProcessedResult) {
    requestMediaFor(indexPath, config: config, shouldRequestVideo: true, result: result)
  }
  
  func prepareItemsAt(_ indexPaths: [IndexPath], config: ImageRequestConfig) {
    let assetsToPreheat = indexPaths.map {
      return assets[$0.section].object(at: $0.item)
    }
    
    imageManager.startCachingImages(for: assetsToPreheat, targetSize: config.size, contentMode: config.contentMode, options: nil)
  }
  
  func dropPreparedItemsAt(_ indexPaths: [IndexPath], config: ImageRequestConfig) {
    //do not drop specific items as it's error prone due to filter may change
    //we drop all cache in the end
  }
  
  func numberOfSections() -> Int {
     return assets.count
  }
  
  func numberOfItemsInSection(_ section: Int) -> Int {
    guard assets.count > 0 else {
      return 0
    }
    return assets[section].count
  }
  
  func initalFetchData() {
    authotizeAndFetch()
  }
  
  func fetchData() {
    let options = PHFetchOptions()
    options.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
    
    switch config {
    case .singleImageItem:
      options.predicate = NSPredicate(format: "mediaType = %d", PHAssetMediaType.image.rawValue)
    case .multipleItems:
      break
    case .images:
      options.predicate = NSPredicate(format: "mediaType = %d", PHAssetMediaType.image.rawValue)
    }
    
    switch currentMediaAlbum {
    case .none:
      assets = [PHAsset.fetchAssets(with: options)]
    case .smartAlbum(let collection):
      assets = [PHAsset.fetchAssets(in: collection, options: options)]
    case .userCollection(let userCollection):
      guard let collection = userCollection as? PHAssetCollection else {
        assets = [PHAsset.fetchAssets(with: options)]
        return
      }
      assets = [PHAsset.fetchAssets(in: collection, options: options)]
    }
    
    presenter.presentReload()
  }
}

// MARK: - Interactor Viper Components Api
private extension MediaPickInteractor {
    var presenter: MediaPickPresenterApi {
        return _presenter as! MediaPickPresenterApi
    }
}

//MARK:- Helpers

extension MediaPickInteractor {
  fileprivate func requestMediaFor(_ indexPath: IndexPath, config: ImageRequestConfig, shouldRequestVideo: Bool, result: @escaping MediaRequestWithProcessedResult) {
    let asset = assets[indexPath.section].object(at: indexPath.item)
    
    imageManager.requestImage(for: asset, targetSize: config.size, contentMode: config.contentMode, options: imageRequestOptions) { [weak self] (image, _) in
      guard let originalAspectImage = image else {
        result(nil, nil, nil, indexPath)
        return
      }
      
      self?.mediaLibraryExportService.resizeImageWithCurrentExportSettings(image: originalAspectImage, cropPerCent: UIEdgeInsets.zero) { [weak self] in
        result(originalAspectImage, $0, nil, indexPath)
        
        guard shouldRequestVideo && asset.mediaType == .video else {
          return
        }
        let resizedImage = $0
        self?.imageManager.requestPlayerItem(forVideo: asset, options: nil, resultHandler: { (playerItem, _) in
          
          guard let playerItem = playerItem else {
            return
          }
          
          DispatchQueue.global(qos: .utility).async {
            let player = AVPlayer(playerItem: playerItem)
            let layer = AVPlayerLayer(player: player)
            
            DispatchQueue.main.async {
              result(originalAspectImage, resizedImage, layer, indexPath)
            }
          }
        })
      }
    }
  }
  
  fileprivate func authotizeAndFetch(){
    let status = PHPhotoLibrary.authorizationStatus()
    switch status {
    case .authorized:
      DispatchQueue.main.async { [weak self] in
        self?.fetchData()
      }
      
    case .denied:
      presenter.handleError(MediaPick.MediaPickError.access)
    case .notDetermined:
      PHPhotoLibrary.requestAuthorization({ [weak self] (status) in
        if status == PHAuthorizationStatus.authorized {
          DispatchQueue.main.async { [weak self] in
            self?.fetchData()
          }
        } else {
          self?.presenter.handleError(MediaPick.MediaPickError.access)
        }
      })
    case .restricted:
      presenter.handleError(MediaPick.MediaPickError.access)
    }
  }
}
