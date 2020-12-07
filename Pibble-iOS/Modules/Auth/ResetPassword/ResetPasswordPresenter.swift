//
//  ResetPasswordModulePresenter.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 26.06.2018.
//Copyright © 2018 com.kazai. All rights reserved.
//

import Foundation

// MARK: - ResetPasswordModulePresenter Class
final class ResetPasswordPresenter: Presenter {
  override func viewDidLoad() {
    super.viewDidLoad()
    ResetPassword.InputFields.allCases.forEach {
      viewController.showPlaceholder(for: $0, hidden: false)
    }
  }
}

// MARK: - ResetPasswordModulePresenter API
extension ResetPasswordPresenter: ResetPasswordPresenterApi {
  func presentPasswordResetFail() {
    viewController.setInteractionEnabled(true)
  }
  
  func handleHideAction() {
    router.routeToRoot()
  }
  
  func handleResetPasswordAction() {
    viewController.setInteractionEnabled(false)
    interactor.performResetPasswordWithCurrentValues()
  }
  
  func presentSuccessfulPasswordReset() {
    viewController.setInteractionEnabled(true)
    router.routeToPasswordResetSuccess()
  }
  
  func handleValueChangedForField(_ field: ResetPassword.InputFields, value: String) {
    viewController.showPlaceholder(for: field, hidden: !value.isEmpty)
    interactor.updateValueFor(field, value: value)
  }
}

// MARK: - ResetPasswordModule Viper Components
fileprivate extension ResetPasswordPresenter {
    var viewController: ResetPasswordViewControllerApi {
        return _viewController as! ResetPasswordViewControllerApi
    }
    var interactor: ResetPasswordInteractorApi {
        return _interactor as! ResetPasswordInteractorApi
    }
    var router: ResetPasswordRouterApi {
        return _router as! ResetPasswordRouterApi
    }
}
