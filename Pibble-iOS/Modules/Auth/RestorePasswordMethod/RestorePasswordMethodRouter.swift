//
//  RestorePasswordMethodModuleRouter.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 22.06.2018.
//Copyright © 2018 com.kazai. All rights reserved.
//

import Foundation

// MARK: - RestorePasswordMethodModuleRouter class
final class RestorePasswordMethodRouter: Router {
}

// MARK: - RestorePasswordMethodModuleRouter API
extension RestorePasswordMethodRouter: RestorePasswordMethodRouterApi {
  func routeToCodeVerificationWith(_ phone: UserPhoneNumberProtocol) {
    AppModules
      .Auth
      .resetPasswordVerifyCode(.pinCode(.phoneNumber(phone)))
      .build()?
      .router
      .present(withPushfrom: presenter._viewController)
  }
  
  func routeToCodeVerificationWith(_ email: ResetPasswordEmailProtocol) {
    AppModules
      .Auth
      .resetPasswordVerifyCode(.pinCode(.email(email)))
      .build()?
      .router
      .present(withPushfrom: presenter._viewController)
  }
  
  func routeToEmailRestoreModule() {
    AppModules
      .Auth
      .resetPasswordWithEmail
      .build()?
      .router
      .present(withPushfrom: presenter._viewController)
  }
  
  func routeToSMSRestoreModule() {
    AppModules
      .Auth
      .resetPasswordPhonePick
      .build()?
      .router
      .present(withPushfrom: presenter._viewController)
  }
}

// MARK: - RestorePasswordMethodModule Viper Components
fileprivate extension RestorePasswordMethodRouter {
    var presenter: RestorePasswordMethodPresenterApi {
        return _presenter as! RestorePasswordMethodPresenterApi
    }
}
