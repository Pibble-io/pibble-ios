//
//  AboutHomeRouter.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 05.10.2018.
//Copyright © 2018 com.kazai. All rights reserved.
//

import UIKit

// MARK: - AboutHomeRouter class
final class AboutHomeRouter: Router {
}

// MARK: - AboutHomeRouter API
extension AboutHomeRouter: AboutHomeRouterApi {
  func routeToLogin() {
    if let module = AppModules.Auth.signIn.build(),
      let window = UIApplication.shared.delegate?.window {
      module.router.show(inWindow: window, embedInNavController: true, animated: true)
    }
  }
}

// MARK: - AboutHome Viper Components
fileprivate extension AboutHomeRouter {
    var presenter: AboutHomePresenterApi {
        return _presenter as! AboutHomePresenterApi
    }
}
