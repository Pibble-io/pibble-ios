//
//  UsersListingRouter.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 10.11.2018.
//Copyright © 2018 com.kazai. All rights reserved.
//

import Foundation

// MARK: - UsersListingRouter class
final class UsersListingRouter: Router {
  
}

// MARK: - UsersListingRouter API
extension UsersListingRouter: UsersListingRouterApi {
  func routeToUserProfileFor(_ user: UserProtocol) {
    let targetUser: UserProfileContent.TargetUser = (user.isCurrent ?? false) ? .current : .other(user)
    
    AppModules
      .UserProfile
      .userProfileContainer(targetUser)
      .build()?
      .router.present(withPushfrom: presenter._viewController)
  }
  
  func routeToFollowedTagsFor(_ user: UserProtocol) {
    AppModules
      .UserProfile
      .tagsListing(.followedBy(user))
      .build()?
      .router.present(withPushfrom: presenter._viewController)
  }
  
}

// MARK: - UsersListing Viper Components
fileprivate extension UsersListingRouter {
    var presenter: UsersListingPresenterApi {
        return _presenter as! UsersListingPresenterApi
    }
}
