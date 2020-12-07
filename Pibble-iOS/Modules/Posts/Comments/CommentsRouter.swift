//
//  CommentsRouter.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 10.08.2018.
//  Copyright © 2018 com.kazai. All rights reserved.
//

import Foundation

// MARK: - CommentsRouter class

final class CommentsRouter: Router {
  
}

// MARK: - CommentsRouter API

extension CommentsRouter: CommentsRouterApi {
  func routeToUpVote(delegate: UpVoteDelegateProtocol) {
    AppModules
      .Posts
      .upVote(delegate, .comment)
      .build()?
      .router.present(withDissolveFrom: presenter._viewController)
  }
  
  func routeToUserProfileFor(_ user: UserProtocol) {
    let targetUser: UserProfileContent.TargetUser = (user.isCurrent ?? false) ? .current : .other(user)
    
    AppModules
      .UserProfile
      .userProfileContainer(targetUser)
      .build()?
      .router.present(withPushfrom: presenter._viewController)
  }
}

// MARK: - Comments Viper Components

fileprivate extension CommentsRouter {
  var presenter: CommentsPresenterApi {
    return _presenter as! CommentsPresenterApi
  }
}
