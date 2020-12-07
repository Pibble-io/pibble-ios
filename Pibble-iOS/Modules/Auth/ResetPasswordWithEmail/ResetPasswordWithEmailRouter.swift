//
//  ResetPasswordWithEmailModuleRouter.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 22.06.2018.
//Copyright © 2018 com.kazai. All rights reserved.
//

import Foundation

// MARK: - ResetPasswordWithEmailModuleRouter class
final class ResetPasswordWithEmailRouter: Router {
}

// MARK: - ResetPasswordWithEmailModuleRouter API
extension ResetPasswordWithEmailRouter: ResetPasswordWithEmailRouterApi {
  func routeToPasswordResetSendModule(email: ResetPasswordEmailProtocol) {
    AppModules
      .Auth
      .resetPasswordEmailSent(email)
      .build()?
      .router
      .present(withPushfrom: presenter._viewController)
  }
}

// MARK: - ResetPasswordWithEmailModule Viper Components
fileprivate extension ResetPasswordWithEmailRouter {
    var presenter: ResetPasswordWithEmailPresenterApi {
        return _presenter as! ResetPasswordWithEmailPresenterApi
    }
}
