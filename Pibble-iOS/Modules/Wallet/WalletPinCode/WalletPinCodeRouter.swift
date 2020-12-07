//
//  WalletPinCodeRouter.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 12.09.2018.
//Copyright © 2018 com.kazai. All rights reserved.
//

import Foundation

// MARK: - WalletPinCodeRouter class
final class WalletPinCodeRouter: Router {
  
}

// MARK: - WalletPinCodeRouter API
extension WalletPinCodeRouter: WalletPinCodeRouterApi {
  func routeToCodeVerificationWith(_ email: ResetPasswordEmailProtocol) {
    AppModules
      .Auth
      .resetPasswordVerifyCode(.pinCode(.email(email)))
      .build()?
      .router
      .present(withPushfrom: presenter._viewController)
  }
  
  func routeToResetPinCodeMethodPick() {
    AppModules
      .Auth
      .restorePasswordMethod(.pinCode)
      .build()?
      .router.present(withPushfrom: presenter._viewController)
  }
}

// MARK: - WalletPinCode Viper Components
fileprivate extension WalletPinCodeRouter {
    var presenter: WalletPinCodePresenterApi {
        return _presenter as! WalletPinCodePresenterApi
    }
}
