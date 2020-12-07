//
//  PostHelpAnswersRouter.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 10.08.2018.
//Copyright © 2018 com.kazai. All rights reserved.
//

import Foundation

// MARK: - PostHelpAnswersRouter class
final class PostHelpAnswersRouter: Router {
}

// MARK: - PostHelpAnswersRouter API
extension PostHelpAnswersRouter: PostHelpAnswersRouterApi {
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

// MARK: - PostHelpAnswers Viper Components
fileprivate extension PostHelpAnswersRouter {
    var presenter: PostHelpAnswersPresenterApi {
        return _presenter as! PostHelpAnswersPresenterApi
    }
}
