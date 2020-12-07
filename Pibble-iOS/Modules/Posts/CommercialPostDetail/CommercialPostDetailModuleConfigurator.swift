//
//  CommercialPostDetailModuleConfigurator.swift
//  Pibble-iOS
//
//  Created by Sergey Kazakov on 06/02/2019.
//Copyright © 2019 com.kazai. All rights reserved.
//

import UIKit

enum CommercialPostDetailModuleConfigurator: ModuleConfigurator {
  case defaultConfig(ServiceContainerProtocol, CommercialPostDetail.CommercialPostType, CommercialPostDetailDelegateProtocol)
  
  var components: ModuleComponents {
    switch self {
    case .defaultConfig(let diContainer, let commercialPostType, let delegate):
      return (V: CommercialPostDetailViewController.self,
              I: CommercialPostDetailInteractor(chatService: diContainer.chatService,
                                             walletService: diContainer.walletService,
                                             coreDataStorage: diContainer.coreDataStorageService,
                                             commercialPostType: commercialPostType),
              P: CommercialPostDetailPresenter(delegate: delegate),
              R: CommercialPostDetailRouter())
    }
  }
}
