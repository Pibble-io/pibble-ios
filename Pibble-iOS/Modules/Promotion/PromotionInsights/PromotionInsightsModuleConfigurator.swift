//
//  PromotionInsightsModuleConfigurator.swift
//  Pibble-iOS
//
//  Created by Sergey Kazakov on 12/06/2019.
//Copyright © 2019 com.kazai. All rights reserved.
//

import UIKit

enum PromotionInsightsModuleConfigurator: ModuleConfigurator {
  case defaultConfig(ServiceContainerProtocol, PostPromotionProtocol)
  
  var components: ModuleComponents {
    switch self {
    case .defaultConfig(let diContainer, let promotion):
      return (V: PromotionInsightsViewController.self,
              I: PromotionInsightsInteractor(promotionService: diContainer.promotionService, promotion: promotion),
              P: PromotionInsightsPresenter(),
              R: PromotionInsightsRouter())
    }
  }
}
