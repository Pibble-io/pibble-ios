//
//  OnboardingRouter.swift
//  Pibble-iOS
//
//  Created by Sergey Kazakov on 04/07/2019.
//Copyright © 2019 com.kazai. All rights reserved.
//

import UIKit

// MARK: - OnboardingRouter class
final class OnboardingRouter: Router {
  
}

// MARK: - OnboardingRouter API
extension OnboardingRouter: OnboardingRouterApi {
  func routeToSignUpModule() {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate,
      let window = appDelegate.window else {
        return
    }

    AppModules
      .Auth
      .registration
      .build()?
      .router.show(inWindow: window, embedInNavController: true, animated: true)
  }
}

// MARK: - Onboarding Viper Components
fileprivate extension OnboardingRouter {
  var presenter: OnboardingPresenterApi {
    return _presenter as! OnboardingPresenterApi
  }
}
