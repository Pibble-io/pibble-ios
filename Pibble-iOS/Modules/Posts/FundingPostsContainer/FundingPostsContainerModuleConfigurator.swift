//
//  FundingPostsContainerModuleConfigurator.swift
//  Pibble-iOS
//
//  Created by Sergey Kazakov on 10/06/2019.
//Copyright © 2019 com.kazai. All rights reserved.
//

import UIKit

enum FundingPostsContainerModuleConfigurator: ModuleConfigurator {
  case defaultConfig(AccountProfileProtocol)
  
  var components: ModuleComponents {
    switch self {
    case .defaultConfig(let accountProfile):
      return (V: FundingPostsContainerViewController.self,
              I: FundingPostsContainerInteractor(currentUserProfile: accountProfile),
              P: FundingPostsContainerPresenter(),
              R: FundingPostsContainerRouter())
    }
  }
}
