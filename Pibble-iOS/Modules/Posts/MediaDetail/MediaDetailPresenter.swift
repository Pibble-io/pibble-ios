//
//  MediaDetailPresenter.swift
//  Pibble-iOS
//
//  Created by Sergey Kazakov on 06/05/2019.
//Copyright © 2019 com.kazai. All rights reserved.
//

import UIKit

// MARK: - MediaDetailPresenter Class
final class MediaDetailPresenter: Presenter {
  override func viewDidAppear() {
    super.viewDidAppear()
    
    switch interactor.contentType {
    case .resized(_):
      break
    case .original(_):
      viewController.presentDownloadingStatusAlert()
    case .empty:
      break
    }
  }

  override func viewWillAppear() {
    super.viewWillAppear()
    let vm = getViewModelFor(interactor.contentType)
    viewController.setMediaViewModel(vm)
  }
}

// MARK: - MediaDetailPresenter API
extension MediaDetailPresenter: MediaDetailPresenterApi {
  func handleHideAction() {
    router.dismiss()
  }
}

// MARK: - MediaDetail Viper Components
fileprivate extension MediaDetailPresenter {
  var viewController: MediaDetailViewControllerApi {
    return _viewController as! MediaDetailViewControllerApi
  }
  var interactor: MediaDetailInteractorApi {
    return _interactor as! MediaDetailInteractorApi
  }
  var router: MediaDetailRouterApi {
    return _router as! MediaDetailRouterApi
  }
}

//MARK:- Helper

extension MediaDetailPresenter {
  fileprivate func getViewModelFor(_ mediaContentType: MediaDetail.MediaContentType) -> MediaDetail.MediaDetailMediaViewModel {
    let contentSize: CGSize
    let urlString: String
    let thumbnailImageUrlString: String
    let contentType: ContentType
    
    switch mediaContentType {
    case .resized(let media):
      contentSize = CGSize(width: media.contentWidth, height:  media.contentHeight)
      urlString = media.mediaUrl
      thumbnailImageUrlString = media.mediaUrl
      contentType = media.contentType
    case .original(let media):
      contentSize = CGSize(width: media.contentOriginalWidth, height:  media.contentOriginalHeight)
      urlString = interactor.getDigitalGoodMediaUrlString(media)
      thumbnailImageUrlString = media.mediaUrl
      contentType = media.contentType
    case .empty:
      contentSize = CGSize.zero
      urlString = ""
      thumbnailImageUrlString = ""
      contentType = .unknown
    }
    
    
    return MediaDetail.MediaDetailMediaViewModel(contentSize: contentSize,
                                                 urlString: urlString,
                                                 thumbnailImageUrlString: thumbnailImageUrlString,
                                                 contentType: contentType)
  }
}
