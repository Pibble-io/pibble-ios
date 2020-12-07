//
//  GiftsFeedModuleApi.swift
//  Pibble-iOS
//
//  Created by Sergey Kazakov on 20/05/2019.
//Copyright © 2019 com.kazai. All rights reserved.
//

import Foundation

//MARK: - GiftsFeedRouter API
protocol GiftsFeedRouterApi: RouterProtocol {
  func routeToSearchScreen()
}

//MARK: - GiftsFeedView API
protocol GiftsFeedViewControllerApi: ViewControllerProtocol {
  func setNavigationBarTitle(_ title: String)
  func setWebViewUrl(_ url: URL)
  func setSearchButtonHidden(_ hidden: Bool)
}

//MARK: - GiftsFeedPresenter API
protocol GiftsFeedPresenterApi: PresenterProtocol {
  func handleHideAction()
  func handleExitAction()
  
  func presentURL(_ url: URL)
  func handleSearchAction()
}

//MARK: - GiftsFeedInteractor API
protocol GiftsFeedInteractorApi: InteractorProtocol {
  var contentType: GiftsFeed.ContentType { get }
  
  func intitialFetchData()
}
