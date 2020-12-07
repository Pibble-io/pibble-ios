//
//  SignInModuleRouter.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 21.06.2018.
//Copyright © 2018 com.kazai. All rights reserved.
//

import UIKit

// MARK: - SignInModuleRouter class
final class SignInRouter: Router {
}

// MARK: - SignInModuleRouter API
extension SignInRouter: SignInRouterApi {
  func routeToSignUp() {
    AppModules
      .Auth
      .registration
      .build()?
      .router
      .present(withFlipFrom: presenter._viewController, embedInNavController: true)
  }
  
  func routeToPhonePick() {
    AppModules
      .Auth
      .phonePick
      .build()?
      .router
      .present(withPushfrom:  presenter._viewController)
  }
  
  func routeToMainTabbar() {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate,
      let window = appDelegate.window else {
        return
    }
    let module = AppModules.Main.tabBar.build()
    module?.router.show(inWindow: window, embedInNavController: true)
  }
  
  func routeToRestorePasswordModule() {
    AppModules
      .Auth
      .resetPasswordWithEmail
      .build()?
      .router
      .present(withPushfrom:  presenter._viewController)
  }
  
  func routeToConfirmation(email: String, shouldConfirmEmail: Bool, shouldConfirmPhone: Bool) {
    guard !shouldConfirmEmail else {
      AppModules
        .Auth
        .verifyCode(VerifyCode.Purpose.forcedEmailVerification(email: email, phoneVerificationNeeded: shouldConfirmPhone))
        .build()?
        .router
        .present(withPushfrom:  presenter._viewController)
      
      return
    }
    
    guard shouldConfirmPhone else {
      return
    }
    
    AppModules
      .Auth
      .phonePick
      .build()?
      .router
      .present(withPushfrom:  presenter._viewController)
  }
  
}

// MARK: - SignInModule Viper Components
fileprivate extension SignInRouter {
    var presenter: SignInPresenterApi {
        return _presenter as! SignInPresenterApi
    }
}
