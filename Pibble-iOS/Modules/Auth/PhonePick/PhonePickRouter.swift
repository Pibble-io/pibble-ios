//
//  PhonePickModuleRouter.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 18.06.2018.
//Copyright © 2018 com.kazai. All rights reserved.
//

import Foundation

// MARK: - PhonePickModuleRouter class
final class PhonePickRouter: Router {
}

// MARK: - PhonePickModuleRouter API
extension PhonePickRouter: PhonePickRouterApi {
  func routeToVerifyCodeWith(_ phoneNumber: UserPhoneNumberProtocol) {
    AppModules
      .Auth
      .verifyCode(.phoneVerification(phoneNumber))
      .build()?
      .router
      .present(withPushfrom: presenter._viewController)
  }
}

// MARK: - PhonePickModule Viper Components
fileprivate extension PhonePickRouter {
    var presenter: PhonePickPresenterApi {
        return _presenter as! PhonePickPresenterApi
    }
}
