//
//  PromotionDestinationPickModuleConfigurator.swift
//  Pibble-iOS
//
//  Created by Sergey Kazakov on 23/05/2019.
//Copyright © 2019 com.kazai. All rights reserved.
//

import UIKit

enum PromotionDestinationPickModuleConfigurator: ModuleConfigurator {
  case defaultConfig(PostingProtocol)
  
  var components: ModuleComponents {
    switch self {
    case .defaultConfig(let post):
      return (V: PromotionDestinationPickViewController.self,
              I: PromotionDestinationPickInteractor(promotionDraft: PromotionDraft(post: post)),
              P: PromotionDestinationPickPresenter(),
              R: PromotionDestinationPickRouter())
    }
  }
}
