//
//  ResetPasswordEmailSentModuleRouter.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 25.06.2018.
//Copyright © 2018 com.kazai. All rights reserved.
//

import Foundation

// MARK: - ResetPasswordEmailSentModuleRouter class
final class ResetPasswordEmailSentRouter: Router {
}

// MARK: - ResetPasswordEmailSentModuleRouter API
extension ResetPasswordEmailSentRouter: ResetPasswordEmailSentRouterApi {
  func routeToVerifyCodeWith(_ email: ResetPasswordEmailProtocol) {
    AppModules
      .Auth
      .resetPasswordVerifyCode(.password(.email(email)))
      .build()?
      .router
      .present(withPushfrom: presenter._viewController)
  }
}

// MARK: - ResetPasswordEmailSentModule Viper Components
fileprivate extension ResetPasswordEmailSentRouter {
    var presenter: ResetPasswordEmailSentPresenterApi {
        return _presenter as! ResetPasswordEmailSentPresenterApi
    }
}
