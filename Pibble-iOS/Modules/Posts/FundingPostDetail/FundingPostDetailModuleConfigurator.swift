//
//  FundingPostDetailModuleConfigurator.swift
//  Pibble-iOS
//
//  Created by Sergey Kazakov on 06/02/2019.
//Copyright © 2019 com.kazai. All rights reserved.
//

import UIKit

enum FundingPostDetailModuleConfigurator: ModuleConfigurator {
  case defaultConfig(ServiceContainerProtocol, PostingProtocol, FundingPostDetail.PresentationType, FundingDetailDelegateProtocol)
  
  var components: ModuleComponents {
    switch self {
    case .defaultConfig(let diContainer, let post, let presentationType, let delegate):
      return (V: FundingPostDetailViewController.self,
              I: FundingPostDetailInteractor(chatService: diContainer.chatService,
                                             accountProfileService: diContainer.accountProfileService,
                                             coreDataStorage: diContainer.coreDataStorageService,
                                             postingService: diContainer.postingService,
                                             post: post),
              P: FundingPostDetailPresenter(presentationType: presentationType, delegate: delegate),
              R: FundingPostDetailRouter())
    }
  }
}
