//
//  WalletInvoiceCreateFriendsContentModuleConfigurator.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 01.09.2018.
//Copyright © 2018 com.kazai. All rights reserved.
//

import UIKit

enum WalletInvoiceCreateFriendsContentModuleConfigurator: ModuleConfigurator {
  case defaultConfig(ServiceContainerProtocol, WalletInvoiceCreateFriendsContent.ContentType, UserPickDelegateProtocol)
  
  var components: ModuleComponents {
    switch self {
    case .defaultConfig(let diContainer, let contentType, let userPickDelegate):
      return (V: WalletInvoiceCreateFriendsContentViewController.self,
              I: WalletInvoiceCreateFriendsContentInteractor(coreDataStorage: diContainer.coreDataStorageService,
                                                             walletService: diContainer.walletService,
                                                             accountProfileService: diContainer.accountProfileService,
                                                             userInteractionService: diContainer.userInteractionService,
                                                             contentType: contentType),
              P: WalletInvoiceCreateFriendsContentPresenter(userPickDelegate: userPickDelegate),
              R: WalletInvoiceCreateFriendsContentRouter())
    }
  }
}
