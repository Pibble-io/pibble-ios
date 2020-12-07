//
//  CommerceTypePickRouter.swift
//  Pibble-iOS
//
//  Created by Sergey Kazakov on 15/05/2019.
//Copyright © 2019 com.kazai. All rights reserved.
//

import Foundation

// MARK: - CommerceTypePickRouter class
final class CommerceTypePickRouter: Router {
}

// MARK: - CommerceTypePickRouter API
extension CommerceTypePickRouter: CommerceTypePickRouterApi {
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

// MARK: - CommerceTypePick Viper Components
fileprivate extension CommerceTypePickRouter {
  var presenter: CommerceTypePickPresenterApi {
    return _presenter as! CommerceTypePickPresenterApi
  }
}
