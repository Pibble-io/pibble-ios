//
//  ResetPasswordWithEmailModulePresenter.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 22.06.2018.
//Copyright © 2018 com.kazai. All rights reserved.
//

import Foundation

// MARK: - ResetPasswordWithEmailModulePresenter Class
final class ResetPasswordWithEmailPresenter: Presenter {
  override func viewDidLoad() {
    super.viewDidLoad()
    viewController.showPlaceholderForEmail(hidden: false)
  }
}

// MARK: - ResetPasswordWithEmailModulePresenter API
extension ResetPasswordWithEmailPresenter: ResetPasswordWithEmailPresenterApi {
  func presentSendPasswordResetFailed() {
    viewController.setInteractionEnabled(true)
  }
  
  func handleHideAction() {
    router.dismiss()
  }
  
  func presentSuccessfulSendPasswordResetTo(_ email: ResetPasswordEmailProtocol) {
    viewController.setInteractionEnabled(true)
    router.routeToPasswordResetSendModule(email: email)
  }
  
  func handleResetPasswordAction() {
    viewController.setInteractionEnabled(false)
    interactor.performResetPasswordWithCurentValues()
  }
  
  func handleEmailValueChanged(_ value: String) {
    viewController.showPlaceholderForEmail(hidden: !value.isEmpty)
    interactor.setEmail(value)
  }
}

// MARK: - ResetPasswordWithEmailModule Viper Components
fileprivate extension ResetPasswordWithEmailPresenter {
    var viewController: ResetPasswordWithEmailViewControllerApi {
        return _viewController as! ResetPasswordWithEmailViewControllerApi
    }
    var interactor: ResetPasswordWithEmailInteractorApi {
        return _interactor as! ResetPasswordWithEmailInteractorApi
    }
    var router: ResetPasswordWithEmailRouterApi {
        return _router as! ResetPasswordWithEmailRouterApi
    }
}
