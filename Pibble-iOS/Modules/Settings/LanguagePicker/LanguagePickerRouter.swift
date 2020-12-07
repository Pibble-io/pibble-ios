//
//  LanguagePickerRouter.swift
//  Pibble-iOS
//
//  Created by Sergey Kazakov on 15/05/2019.
//Copyright © 2019 com.kazai. All rights reserved.
//

import Foundation

// MARK: - LanguagePickerRouter class
final class LanguagePickerRouter: Router {
}

// MARK: - LanguagePickerRouter API
extension LanguagePickerRouter: LanguagePickerRouterApi {
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

// MARK: - LanguagePicker Viper Components
fileprivate extension LanguagePickerRouter {
  var presenter: LanguagePickerPresenterApi {
    return _presenter as! LanguagePickerPresenterApi
  }
}
