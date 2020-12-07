//
//  CreatePostHelpRouter.swift
//  Pibble-iOS
//
//  Created by Sergey Kazakov on 26/09/2019.
//Copyright © 2019 com.kazai. All rights reserved.
//

import Foundation

// MARK: - CreatePostHelpRouter class
final class CreatePostHelpRouter: Router {
}

// MARK: - CreatePostHelpRouter API
extension CreatePostHelpRouter: CreatePostHelpRouterApi {
  func routeToPickReward(delegate: PostHelpRewardPickDelegateProtocol) {
    AppModules
      .PostHelp
      .postHelpRewardPick(delegate)
      .build()?
      .router.present(withDissolveFrom: _presenter._viewController)
    
  }
}

// MARK: - CreatePostHelp Viper Components
fileprivate extension CreatePostHelpRouter {
  var presenter: CreatePostHelpPresenterApi {
    return _presenter as! CreatePostHelpPresenterApi
  }
}
