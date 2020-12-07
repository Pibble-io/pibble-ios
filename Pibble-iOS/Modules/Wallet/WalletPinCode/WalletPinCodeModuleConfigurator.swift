//
//  WalletPinCodeModuleConfigurator.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 12.09.2018.
//Copyright © 2018 com.kazai. All rights reserved.
//

import UIKit

enum WalletPinCodeModuleConfigurator: ModuleConfigurator {
  case defaultConfig(ServiceContainerProtocol, WalletPinCode.PinCodePurpose, WalletPinCodeUnlockDelegateProtocol)
  
  var components: ModuleComponents {
    switch self {
    case .defaultConfig(let diContainer, let pinCodePurpose, let delegate):
      return (V: WalletPinCodeViewController.self,
              I: WalletPinCodeInteractor(walletService: diContainer.walletService,
                                         accountProfileService: diContainer.accountProfileService,
                                         authService: diContainer.loginService,
                                         pinCodePurpose: pinCodePurpose),
              P: WalletPinCodePresenter(pinCodeUnlockDelegate: delegate),
              R: WalletPinCodeRouter())
    }
  }
}
