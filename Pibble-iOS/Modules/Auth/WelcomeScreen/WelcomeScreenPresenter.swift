//
//  WelcomeModulePresenter.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 28.06.2018.
//Copyright © 2018 com.kazai. All rights reserved.
//

import Foundation

// MARK: - WelcomeModulePresenter Class
final class WelcomeScreenPresenter: Presenter {
}

// MARK: - WelcomeModulePresenter API
extension WelcomeScreenPresenter: WelcomeScreenPresenterApi {
  func handleContinueAction() {
    router.routeToMainTabbar()
  }
  
  func handleSwitchAccountAction() {
     router.routeToSwitchAccount()
  }
}

// MARK: - WelcomeModule Viper Components
fileprivate extension WelcomeScreenPresenter {
    var viewController: WelcomeScreenViewControllerApi {
        return _viewController as! WelcomeScreenViewControllerApi
    }
    var interactor: WelcomeScreenInteractorApi {
        return _interactor as! WelcomeScreenInteractorApi
    }
    var router: WelcomeScreenRouterApi {
        return _router as! WelcomeScreenRouterApi
    }
}
