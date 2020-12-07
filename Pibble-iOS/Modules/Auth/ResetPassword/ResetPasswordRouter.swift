//
//  ResetPasswordModuleRouter.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 26.06.2018.
//Copyright © 2018 com.kazai. All rights reserved.
//

import UIKit

// MARK: - ResetPasswordModuleRouter class
final class ResetPasswordRouter: Router {
}

// MARK: - ResetPasswordModuleRouter API
extension ResetPasswordRouter: ResetPasswordRouterApi {
  func routeToPasswordResetSuccess() {
    AppModules
      .Auth
      .resetPasswordSuccess
      .build()?
      .router
      .present(withPushfrom: _presenter._viewController)
  }
}

// MARK: - ResetPasswordModule Viper Components
fileprivate extension ResetPasswordRouter {
    var presenter: ResetPasswordPresenterApi {
        return _presenter as! ResetPasswordPresenterApi
    }
}
