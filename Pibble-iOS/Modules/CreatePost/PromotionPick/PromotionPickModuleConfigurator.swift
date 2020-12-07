//
//  PromotionPickModuleConfigurator.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 21.08.2018.
//Copyright © 2018 com.kazai. All rights reserved.
//

import UIKit

enum PromotionPickModuleConfigurator: ModuleConfigurator {
  case defaultConfig(ServiceContainerProtocol, PromotionPickDelegateProtocol)
  
  var components: ModuleComponents {
    switch self {
    case .defaultConfig(let diContainer, let delegate):
      return (V: PromotionPickViewController.self,
              I: PromotionPickInteractor(walletService: diContainer.walletService),
              P: PromotionPickPresenter(promotionPickDelegate: delegate),
              R: PromotionPickRouter())
    }
  }
}
