//
//  ResetPasswordSuccessModuleRouter.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 27.06.2018.
//Copyright © 2018 com.kazai. All rights reserved.
//

import UIKit

// MARK: - ResetPasswordSuccessModuleRouter class
final class ResetPasswordSuccessRouter: Router {
}

// MARK: - ResetPasswordSuccessModuleRouter API
extension ResetPasswordSuccessRouter: ResetPasswordSuccessRouterApi {
  func routeToLogin() {
    AppModules
      .Auth
      .signIn
      .build()?
      .router
      .present(withPushfrom: _presenter._viewController)
  }
}

// MARK: - ResetPasswordSuccessModule Viper Components
fileprivate extension ResetPasswordSuccessRouter {
    var presenter: ResetPasswordSuccessPresenterApi {
        return _presenter as! ResetPasswordSuccessPresenterApi
    }
}
