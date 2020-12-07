//
//  CreatePromotionConfirmModuleConfigurator.swift
//  Pibble-iOS
//
//  Created by Sergey Kazakov on 05/06/2019.
//Copyright © 2019 com.kazai. All rights reserved.
//

import UIKit

enum CreatePromotionConfirmModuleConfigurator: ModuleConfigurator {
  case defaultConfig(ServiceContainerProtocol, PromotionDraft)
  
  var components: ModuleComponents {
    switch self {
    case .defaultConfig(let diContainer, let promotionDraft):
      return (V: CreatePromotionConfirmViewController.self,
              I: CreatePromotionConfirmInteractor(promotionService: diContainer.promotionService,
                                                  accountProfileService: diContainer.accountProfileService,
                                                  promotionDraft: promotionDraft,
                                                  postingService: diContainer.postingService,
                                                  storageService: diContainer.coreDataStorageService),
              P: CreatePromotionConfirmPresenter(),
              R: CreatePromotionConfirmRouter())
    }
  }
}
