//
//  UpvotedUsersRouter.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 28.09.2018.
//Copyright © 2018 com.kazai. All rights reserved.
//

import Foundation

// MARK: - UpvotedUsersRouter class
final class UpvotedUsersRouter: Router {
}

// MARK: - UpvotedUsersRouter API
extension UpvotedUsersRouter: UpvotedUsersRouterApi {
  func routeToUserProfileFor(_ user: UserProtocol) {
    let targetUser: UserProfileContent.TargetUser = (user.isCurrent ?? false) ? .current : .other(user)
    
    AppModules
      .UserProfile
      .userProfileContainer(targetUser)
      .build()?
      .router.present(withPushfrom: presenter._viewController)
  }
  
  func routeToUpVote(delegate: UpVoteDelegateProtocol, purpose: UpVote.UpvotePurpose) {
    AppModules
      .Posts
      .upVote(delegate, purpose)
      .build()?
      .router.present(withDissolveFrom: presenter._viewController)
  }
}

// MARK: - UpvotedUsers Viper Components
fileprivate extension UpvotedUsersRouter {
    var presenter: UpvotedUsersPresenterApi {
        return _presenter as! UpvotedUsersPresenterApi
    }
}
