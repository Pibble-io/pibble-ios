//
//  PostHelpRewardPickModuleConfigurator.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 05.09.2018.
//Copyright © 2018 com.kazai. All rights reserved.
//

import UIKit

enum PostHelpRewardPickModuleConfigurator: ModuleConfigurator {
  case defaultConfig(ServiceContainerProtocol, PostHelpRewardPickDelegateProtocol)
  
  var components: ModuleComponents {
    switch self {
    case .defaultConfig(let diContainer, let delegate):
      return (V: PostHelpRewardPickViewController.self,
              I: PostHelpRewardPickInteractor(accountProfileService: diContainer.accountProfileService),
              P: PostHelpRewardPickPresenter(upVoteAmountPickDelegate: delegate),
              R: PostHelpRewardPickRouter())
    }
  }
}
