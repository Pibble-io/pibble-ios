//
//  GiftsFeedPresenter.swift
//  Pibble-iOS
//
//  Created by Sergey Kazakov on 20/05/2019.
//Copyright © 2019 com.kazai. All rights reserved.
//

import Foundation

// MARK: - GiftsFeedPresenter Class
final class GiftsFeedPresenter: Presenter {
  override func viewDidLoad() {
    super.viewDidLoad()
    interactor.intitialFetchData()
    switch interactor.contentType {
    case .giftHome:
      viewController.setSearchButtonHidden(false)
      viewController.setNavigationBarTitle(GiftsFeed.Strings.NavigationBarTitles.giftHome.localize())
    case .giftSearch:
      viewController.setSearchButtonHidden(true)
      viewController.setNavigationBarTitle(GiftsFeed.Strings.NavigationBarTitles.search.localize())
    }
  }
}

// MARK: - GiftsFeedPresenter API
extension GiftsFeedPresenter: GiftsFeedPresenterApi {
  
  
  func handleExitAction() {
    router.routeToRoot(animated: true)
  }
  
  func handleSearchAction() {
    router.routeToSearchScreen()
  }
  
  func presentURL(_ url: URL) {
    viewController.setWebViewUrl(url)
  }
  
  func handleHideAction() {
    switch interactor.contentType {
    case .giftHome:
      router.routeToRoot(animated: true)
    case .giftSearch:
      router.dismiss()
    }
  }
}

// MARK: - GiftsFeed Viper Components
fileprivate extension GiftsFeedPresenter {
  var viewController: GiftsFeedViewControllerApi {
    return _viewController as! GiftsFeedViewControllerApi
  }
  var interactor: GiftsFeedInteractorApi {
    return _interactor as! GiftsFeedInteractorApi
  }
  var router: GiftsFeedRouterApi {
    return _router as! GiftsFeedRouterApi
  }
}

extension GiftsFeedPresenter {
  func validatedUrlFor(_ url: URL) -> URL? {
    guard url.absoluteString.hasHttpPrefix else {
      guard let correctedUrl = URL(string: url.absoluteString.stringByAddingHttpPrefix) else {
        return nil
      }
      
      return correctedUrl
    }
    
    return url
  }
}
