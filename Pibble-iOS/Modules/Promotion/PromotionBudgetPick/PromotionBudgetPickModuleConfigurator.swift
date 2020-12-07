//
//  PromotionBudgetPickModuleConfigurator.swift
//  Pibble-iOS
//
//  Created by Sergey Kazakov on 25/05/2019.
//Copyright © 2019 com.kazai. All rights reserved.
//

import UIKit

enum PromotionBudgetPickModuleConfigurator: ModuleConfigurator {
  case defaultConfig(ServiceContainerProtocol, PromotionDraft)
  
  var components: ModuleComponents {
    switch self {
    case .defaultConfig(let diContainer, let promotionDraft):
      return (V: PromotionBudgetPickViewController.self,
              I: PromotionBudgetPickInteractor(promotionService: diContainer.promotionService,
                                               accountProfileService: diContainer.accountProfileService,
                                               promotionDraft: promotionDraft),
              P: PromotionBudgetPickPresenter(),
              R: PromotionBudgetPickRouter())
    }
  }
}
