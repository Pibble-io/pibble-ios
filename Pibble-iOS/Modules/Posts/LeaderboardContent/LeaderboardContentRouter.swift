//
//  LeaderboardContentRouter.swift
//  Pibble-iOS
//
//  Created by Sergey Kazakov on 11/04/2019.
//Copyright © 2019 com.kazai. All rights reserved.
//

import Foundation

// MARK: - LeaderboardContentRouter class
final class LeaderboardContentRouter: Router {
  
}

// MARK: - LeaderboardContentRouter API
extension LeaderboardContentRouter: LeaderboardContentRouterApi {
  func routeToUserProfileFor(_ user: UserProtocol) {
    let targetUser: UserProfileContent.TargetUser = (user.isCurrent ?? false) ? .current : .other(user)
    
    AppModules
      .UserProfile
      .userProfileContainer(targetUser)
      .build()?
      .router.present(withPushfrom: presenter._viewController)
  }
  
  func routeToUserWinPostsFor(_ user: UserProtocol) {
    let config: PostsFeed.FeedType = .winnerPosts(user)
    let configurator = PostsFeedModuleConfigurator.userPostsConfig(AppModules.servicesContainer, config, shouldScrollToPost: nil)
    
    AppModules
      .Posts
      .postsFeed(config)
      .build(configurator: configurator)?
      .router.present(withPushfrom: presenter._viewController)
  }
}

// MARK: - LeaderboardContent Viper Components
fileprivate extension LeaderboardContentRouter {
  var presenter: LeaderboardContentPresenterApi {
    return _presenter as! LeaderboardContentPresenterApi
  }
}
