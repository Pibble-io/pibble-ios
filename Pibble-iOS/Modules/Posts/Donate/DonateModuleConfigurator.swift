//
//  DonateModuleConfigurator.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 30.10.2018.
//Copyright © 2018 com.kazai. All rights reserved.
//

import UIKit

enum DonateModuleConfigurator: ModuleConfigurator {
  case defaultConfig(ServiceContainerProtocol, DonateDelegateProtocol, [BalanceCurrency], Donate.AmountPickType)
  
  var components: ModuleComponents {
    switch self {
    case .defaultConfig(let diContainer, let delegate, let currencies, let amountPickType):
      return (V: DonateViewController.self,
              I: DonateInteractor(accountProfileService: diContainer.accountProfileService,
                                  currencies: currencies,
                                  amountPickType: amountPickType),
              P: DonatePresenter(delegate: delegate),
              R: DonateRouter())
    }
  }
}
