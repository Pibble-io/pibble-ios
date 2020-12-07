//
//  WalletActivityContentModuleConfigurator.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 25.08.2018.
//Copyright © 2018 com.kazai. All rights reserved.
//

import UIKit

enum WalletActivityContentModuleConfigurator: ModuleConfigurator {
  case defaultConfig(ServiceContainerProtocol, WalletActivityContent.ContentType)
  case donationsListingConfig(ServiceContainerProtocol,  WalletActivityContent.ContentType)
  
  var components: ModuleComponents {
    switch self {
    case .defaultConfig(let diContainer, let contentType):
      return (V: WalletActivityContentViewController.self,
              I: WalletActivityContentInteractor(coreDataStorage: diContainer.coreDataStorageService,
                                                 walletService: diContainer.walletService,
                                                 accountProfileService: diContainer.accountProfileService,
                                                 contentType: contentType),
              P: WalletActivityContentPresenter(presentationType: .walletActivities),
              R: WalletActivityContentRouter())
    case .donationsListingConfig(let diContainer, let contentType):
      return (V: WalletActivityPostContributorsViewController.self,
              I: WalletActivityPostContributorsInteractor(coreDataStorage: diContainer.coreDataStorageService,
                                                 walletService: diContainer.walletService,
                                                 accountProfileService: diContainer.accountProfileService,
                                                 contentType: contentType),
              P: WalletActivityContentPresenter(presentationType: .donationTransactions),
              R: WalletActivityContentRouter())
      
    }
  }
}
