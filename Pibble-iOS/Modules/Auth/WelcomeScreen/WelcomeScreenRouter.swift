//
//  WelcomeModuleRouter.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 28.06.2018.
//Copyright © 2018 com.kazai. All rights reserved.
//

import UIKit

// MARK: - WelcomeModuleRouter class
final class WelcomeScreenRouter: Router {
}

// MARK: - WelcomeModuleRouter API
extension WelcomeScreenRouter: WelcomeScreenRouterApi {
  func routeToSwitchAccount() {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate,
      let window = appDelegate.window else {
        return
    }
   
    AppModules
      .Auth
      .registration
      .build()?
      .router
      .show(inWindow: window, embedInNavController: true, animated: true)
  }
  
  func routeToMainTabbar() {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate,
      let window = appDelegate.window else {
        return
    }
    
    AppModules
      .Main
      .tabBar
      .build()?
      .router.show(inWindow: window, embedInNavController: true, animated: true)
  }
  
}

// MARK: - WelcomeModule Viper Components
fileprivate extension WelcomeScreenRouter {
    var presenter: WelcomeScreenPresenterApi {
        return _presenter as! WelcomeScreenPresenterApi
    }
}
