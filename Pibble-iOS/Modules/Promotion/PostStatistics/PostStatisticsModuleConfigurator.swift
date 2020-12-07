//
//  PostStatisticsModuleConfigurator.swift
//  Pibble-iOS
//
//  Created by Sergey Kazakov on 18/06/2019.
//Copyright © 2019 com.kazai. All rights reserved.
//

import UIKit

enum PostStatisticsModuleConfigurator: ModuleConfigurator {
  case defaultConfig(ServiceContainerProtocol, PostingProtocol)
  
  var components: ModuleComponents {
    switch self {
    case .defaultConfig(let diContainer, let post):
      return (V: PostStatisticsViewController.self,
              I: PostStatisticsInteractor(postService: diContainer.postingService, post: post),
              P: PostStatisticsPresenter(),
              R: PostStatisticsRouter())
    }
  }
}
