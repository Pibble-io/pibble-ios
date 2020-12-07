//
//  RegistrationModuleRouter.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 16.06.2018.
//Copyright © 2018 com.kazai. All rights reserved.
//

import UIKit

// MARK: - RegistrationModuleRouter class
final class RegistrationRouter: Router {
}

// MARK: - RegistrationModuleRouter API
extension RegistrationRouter: RegistrationRouterApi {
  func routeToExternalLinkWithUrl(_ url: URL, title: String) {
    AppModules
      .Settings
      .externalLink(url, title)
      .build()?
      .router.present(withPushfrom: presenter._viewController)
  }
  
  func routeToTermsAndPolicyModule(_ url: URL) {
    guard UIApplication.shared.canOpenURL(url) else {
      return
    }
    
    UIApplication.shared.open(url)
  }
  
  func routeToSignInModule() {
    AppModules
      .Auth
      .signIn
      .build()?
      .router
      .present(withFlipFrom: presenter._viewController, embedInNavController: true)
  }
  
  func routeToVerifyEmailModule(_ email: String) {
    AppModules
      .Auth
      .verifyCode(.initialEmailVerification(email))
      .build()?
      .router
      .present(withPushfrom:  presenter._viewController)
  }
}

// MARK: - RegistrationModule Viper Components
fileprivate extension RegistrationRouter {
    var presenter: RegistrationPresenterApi {
        return _presenter as! RegistrationPresenterApi
    }
}
