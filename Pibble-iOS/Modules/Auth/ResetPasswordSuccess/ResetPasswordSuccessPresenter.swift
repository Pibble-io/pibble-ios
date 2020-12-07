//
//  ResetPasswordSuccessModulePresenter.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 27.06.2018.
//Copyright © 2018 com.kazai. All rights reserved.
//

import Foundation

// MARK: - ResetPasswordSuccessModulePresenter Class
final class ResetPasswordSuccessPresenter: Presenter {
}

// MARK: - ResetPasswordSuccessModulePresenter API
extension ResetPasswordSuccessPresenter: ResetPasswordSuccessPresenterApi {
  func handleLoginAction() {
    router.routeToLogin()
  }
}

// MARK: - ResetPasswordSuccessModule Viper Components
fileprivate extension ResetPasswordSuccessPresenter {
    var viewController: ResetPasswordSuccessViewControllerApi {
        return _viewController as! ResetPasswordSuccessViewControllerApi
    }
    var interactor: ResetPasswordSuccessInteractorApi {
        return _interactor as! ResetPasswordSuccessInteractorApi
    }
    var router: ResetPasswordSuccessRouterApi {
        return _router as! ResetPasswordSuccessRouterApi
    }
}
