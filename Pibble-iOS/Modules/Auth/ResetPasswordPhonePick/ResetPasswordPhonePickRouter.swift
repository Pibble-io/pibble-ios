//
//  ResetPasswordPhonePickModuleRouter.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 26.06.2018.
//Copyright © 2018 com.kazai. All rights reserved.
//

import Foundation

// MARK: - ResetPasswordPhonePickModuleRouter class
final class ResetPasswordPhonePickRouter: Router {
}

// MARK: - ResetPasswordPhonePickModuleRouter API
extension ResetPasswordPhonePickRouter: ResetPasswordPhonePickRouterApi {
  func routeToVerifyCodeWith(_ phoneNumber: UserPhoneNumberProtocol) {
    AppModules
      .Auth
      .resetPasswordVerifyCode(.password(.phoneNumber(phoneNumber)))
      .build()?
      .router
      .present(withPushfrom: presenter._viewController)
  }
}

// MARK: - ResetPasswordPhonePickModule Viper Components
fileprivate extension ResetPasswordPhonePickRouter {
    var presenter: ResetPasswordPhonePickPresenterApi {
        return _presenter as! ResetPasswordPhonePickPresenterApi
    }
}
