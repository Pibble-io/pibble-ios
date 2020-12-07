//
//  NotificationsFeedRouter.swift
//  Pibble-iOS
//
//  Created by Sergey Kazakov on 26/06/2019.
//Copyright © 2019 com.kazai. All rights reserved.
//

import Foundation

// MARK: - NotificationsFeedRouter class
final class NotificationsFeedRouter: Router {
}

// MARK: - NotificationsFeedRouter API
extension NotificationsFeedRouter: NotificationsFeedRouterApi {
  func routeToUserProfileFor(_ user: UserProtocol) {
    let targetUser: UserProfileContent.TargetUser = (user.isCurrent ?? false) ? .current : .other(user)
    
    AppModules
      .UserProfile
      .userProfileContainer(targetUser)
      .build()?
      .router.present(withPushfrom: presenter._viewController)
  }
  
  func routeToPostDetailFor(_ post: PostingProtocol) {
    let config: PostsFeed.FeedType = .singlePost(post)
    let configurator = PostsFeedModuleConfigurator.userPostsConfig(AppModules.servicesContainer, config, shouldScrollToPost: post)
    let module = AppModules
      .Posts
      .postsFeed(config)
      .build(configurator: configurator)
    
    module?.router.present(withPushfrom: presenter._viewController)
  }
}

// MARK: - NotificationsFeed Viper Components
fileprivate extension NotificationsFeedRouter {
  var presenter: NotificationsFeedPresenterApi {
    return _presenter as! NotificationsFeedPresenterApi
  }
}
