//
//  MediaDetailModuleApi.swift
//  Pibble-iOS
//
//  Created by Sergey Kazakov on 06/05/2019.
//Copyright © 2019 com.kazai. All rights reserved.
//

import UIKit

//MARK: - MediaDetailRouter API
protocol MediaDetailRouterApi: RouterProtocol {
}

//MARK: - MediaDetailView API
protocol MediaDetailViewControllerApi: ViewControllerProtocol {
  func setMediaViewModel(_ vm: MediaDetailMediaViewModelProtocol)
  func presentDownloadingStatusAlert()
}

//MARK: - MediaDetailPresenter API
protocol MediaDetailPresenterApi: PresenterProtocol {
  func handleHideAction()
}

//MARK: - MediaDetailInteractor API
protocol MediaDetailInteractorApi: InteractorProtocol {
  var contentType: MediaDetail.MediaContentType { get }
  func getDigitalGoodMediaUrlString(_ media: MediaProtocol) -> String
}

protocol MediaDetailMediaViewModelProtocol {
  var contentSize: CGSize { get }
  var urlString: String { get }
  var thumbnailImageUrlString: String { get }
  var contentType: ContentType { get }
}

extension MediaDetailMediaViewModelProtocol {
  var isLandscape: Bool {
    return contentSize.width > contentSize.height
  }
}
