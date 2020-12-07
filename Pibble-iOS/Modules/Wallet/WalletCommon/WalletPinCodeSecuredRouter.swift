//
//  WalletPinCodeSecuredRouter.swift
//  Pibble
//
//  Created by Kazakov Sergey on 27.09.2018.
//  Copyright © 2018 com.kazai. All rights reserved.
//

import Foundation

protocol WalletPinCodeSecuredRouterProtocol: RouterProtocol {
  
}

extension WalletPinCodeSecuredRouterProtocol {
  func routeToPinCodeUnlockWith(delegate: WalletPinCodeUnlockDelegateProtocol) {
    AppModules
      .Wallet
      .walletPinCode(.unlock, delegate)
      .build()?
      .router.show(from: _presenter._viewController, insideView: _presenter._viewController.view)
//      .router.present(withCoverFrom: _presenter._viewController, embedInNavController: true)
  }
}

