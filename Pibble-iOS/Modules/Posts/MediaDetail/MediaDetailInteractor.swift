//
//  MediaDetailInteractor.swift
//  Pibble-iOS
//
//  Created by Sergey Kazakov on 06/05/2019.
//Copyright © 2019 com.kazai. All rights reserved.
//

import Foundation 

// MARK: - MediaDetailInteractor Class
final class MediaDetailInteractor: Interactor {
  let mediaDownloadService: MediaDownloadServiceProtocol
  let contentType: MediaDetail.MediaContentType
  
  init(post: PostingProtocol, media: MediaProtocol, mediaDownloadService: MediaDownloadServiceProtocol) {
    contentType = MediaDetailInteractor.contentTypeFor(post: post, media: media)
    self.mediaDownloadService = mediaDownloadService
  }
}

// MARK: - MediaDetailInteractor API
extension MediaDetailInteractor: MediaDetailInteractorApi {
  func getDigitalGoodMediaUrlString(_ media: MediaProtocol) -> String {
    return mediaDownloadService.getUrlStringForDigitalGoodOriginal(media)
  }
}

// MARK: - Interactor Viper Components Api
private extension MediaDetailInteractor {
  var presenter: MediaDetailPresenterApi {
    return _presenter as! MediaDetailPresenterApi
  }
}

//MARK:- Helper

extension MediaDetailInteractor {
  static func contentTypeFor(post: PostingProtocol, media: MediaProtocol) -> MediaDetail.MediaContentType {
    guard let _ = post.commerceInfo else {
      return .resized(media)
    }
    
    guard !post.isMyPosting else {
      switch media.contentType {
      case .image:
        return .original(media)
      case .video:
        return .original(media)
      case .unknown:
        return .empty
      }
    }
    
    guard let invoice = post.currentUserDigitalGoodPurchaseInvoice,
      invoice.walletActivityStatus == .accepted else {
      return .resized(media)
    }
    
    switch media.contentType {
    case .image:
      return .original(media)
    case .video:
      return .original(media)
    case .unknown:
      return .empty
    }
    
  }
}
