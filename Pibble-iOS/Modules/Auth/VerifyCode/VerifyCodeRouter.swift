//
//  VerifyCodeModuleRouter.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 20.06.2018.
//Copyright © 2018 com.kazai. All rights reserved.
//

import UIKit

// MARK: - VerifyCodeModuleRouter class
final class VerifyCodeRouter: Router {
}

// MARK: - VerifyCodeModuleRouter API
extension VerifyCodeRouter: VerifyCodeRouterApi {
  func routeToLogin() {
    if let module = AppModules.Auth.signIn.build(),
      let window = UIApplication.shared.delegate?.window {
      module.router.show(inWindow: window, embedInNavController: true, animated: true)
    }
  }
  
  func routeToPhonePickModule() {
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
}

// MARK: - VerifyCodeModule Viper Components
fileprivate extension VerifyCodeRouter {
    var presenter: VerifyCodePresenterApi {
        return _presenter as! VerifyCodePresenterApi
    }
}
