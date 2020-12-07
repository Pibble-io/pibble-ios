//
//  PromotionUrlDestinationPickModuleConfigurator.swift
//  Pibble-iOS
//
//  Created by Sergey Kazakov on 24/05/2019.
//Copyright © 2019 com.kazai. All rights reserved.
//

import UIKit

enum PromotionUrlDestinationPickModuleConfigurator: ModuleConfigurator {
  case defaultConfig(ServiceContainerProtocol, PromotionUrlDestinationPickDelegateProtocol)
  
  var components: ModuleComponents {
    switch self {
    case .defaultConfig(let diContainer, let delegate):
      return (V: PromotionUrlDestinationPickViewController.self,
              I: PromotionUrlDestinationPickInteractor(promotionService: diContainer.promotionService),
              P: PromotionUrlDestinationPickPresenter(delegate: delegate),
              R: PromotionUrlDestinationPickRouter())
    }
  }
}
