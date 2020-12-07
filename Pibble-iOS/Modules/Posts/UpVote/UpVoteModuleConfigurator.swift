//
//  UpVoteModuleConfigurator.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 05.09.2018.
//Copyright © 2018 com.kazai. All rights reserved.
//

import UIKit

enum UpVoteModuleConfigurator: ModuleConfigurator {
  case defaultConfig(ServiceContainerProtocol, UpVoteDelegateProtocol, UpVote.UpvotePurpose)
  
  var components: ModuleComponents {
    switch self {
    case .defaultConfig(let diContainer, let delegate, let purpose):
      return (V: UpVoteViewController.self,
              I: UpVoteInteractor(accountProfileService: diContainer.accountProfileService,
                                  purpose: purpose),
              P: UpVotePresenter(upVoteAmountPickDelegate: delegate, purpose: purpose),
              R: UpVoteRouter())
    }
  }
}
