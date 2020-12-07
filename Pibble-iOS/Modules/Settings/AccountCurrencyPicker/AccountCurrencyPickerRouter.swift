//
//  AccountCurrencyPickerRouter.swift
//  Pibble-iOS
//
//  Created by Sergey Kazakov on 15/05/2019.
//Copyright © 2019 com.kazai. All rights reserved.
//

import Foundation

// MARK: - AccountCurrencyPickerRouter class
final class AccountCurrencyPickerRouter: Router {
}

// MARK: - AccountCurrencyPickerRouter API
extension AccountCurrencyPickerRouter: AccountCurrencyPickerRouterApi {
  func routeToNativeCurrencyPicker() {
     
  }
  
  func routeToMyGoodsListForCurrentUser(_ user: UserProtocol) {
    let config: PostsFeed.FeedType = .currentUserCommercePosts(user)
    let configurator = PostsFeedModuleConfigurator.userPostsConfig(AppModules.servicesContainer,
                                                                   config,
                                                                   shouldScrollToPost: nil)
    AppModules
      .Posts
      .postsFeed(config)
      .build(configurator: configurator)?
      .router.present(withPushfrom: presenter._viewController)
  }
  
  func routeToPurchasedGoodsListForCurrentUser(_ user: UserProtocol) {
    let config: PostsFeed.FeedType = .currentUserPurchasedCommercePosts(user)
    let configurator = PostsFeedModuleConfigurator.userPostsConfig(AppModules.servicesContainer,
                                                                   config,
                                                                   shouldScrollToPost: nil)
    AppModules
      .Posts
      .postsFeed(config)
      .build(configurator: configurator)?
      .router.present(withPushfrom: presenter._viewController)
  }
}

// MARK: - AccountCurrencyPicker Viper Components
fileprivate extension AccountCurrencyPickerRouter {
  var presenter: AccountCurrencyPickerPresenterApi {
    return _presenter as! AccountCurrencyPickerPresenterApi
  }
}
