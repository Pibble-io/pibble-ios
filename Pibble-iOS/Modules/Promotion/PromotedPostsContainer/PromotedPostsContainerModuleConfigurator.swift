//
//  PromotedPostsContainerModuleConfigurator.swift
//  Pibble-iOS
//
//  Created by Sergey Kazakov on 10/06/2019.
//Copyright © 2019 com.kazai. All rights reserved.
//

import UIKit

enum PromotedPostsContainerModuleConfigurator: ModuleConfigurator {
  case defaultConfig(AccountProfileProtocol)
  
  var components: ModuleComponents {
    switch self {
    case .defaultConfig(let accountProfile):
      return (V: PromotedPostsContainerViewController.self,
              I: PromotedPostsContainerInteractor(currentUserProfile: accountProfile),
              P: PromotedPostsContainerPresenter(),
              R: PromotedPostsContainerRouter())
    }
  }
}
