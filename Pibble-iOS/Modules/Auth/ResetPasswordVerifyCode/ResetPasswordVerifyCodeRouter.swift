//
//  ResetPasswordVerifyCodeModuleRouter.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 26.06.2018.
//Copyright © 2018 com.kazai. All rights reserved.
//

import UIKit

// MARK: - ResetPasswordVerifyCodeModuleRouter class
final class ResetPasswordVerifyCodeRouter: Router {
}

// MARK: - ResetPasswordVerifyCodeModuleRouter API
extension ResetPasswordVerifyCodeRouter: ResetPasswordVerifyCodeRouterApi {
  func routeToLogin() {
    if let module = AppModules.Auth.signIn.build(),
      let window = UIApplication.shared.delegate?.window {
      module.router.show(inWindow: window, embedInNavController: true, animated: true)
    }
  }
  
  func routeToChangePasswordWith(confirmationToken: String) {
    AppModules
      .Auth
      .resetPassword(confirmationToken)
      .build()?
      .router
      .present(withPushfrom: presenter._viewController)
  }
  
  func routeToChangePinCodeWith(confirmationToken: String, delegate: WalletPinCodeUnlockDelegateProtocol) {
    AppModules
      .Wallet
      .walletPinCode(.restorePinCode(token: confirmationToken), delegate)
      .build()?
      .router
      .present(withPushfrom: presenter._viewController)
  }
}

// MARK: - ResetPasswordVerifyCodeModule Viper Components
fileprivate extension ResetPasswordVerifyCodeRouter {
    var presenter: ResetPasswordVerifyCodePresenterApi {
        return _presenter as! ResetPasswordVerifyCodePresenterApi
    }
}
