//
//  SignInModulePresenter.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 21.06.2018.
//Copyright © 2018 com.kazai. All rights reserved.
//

import Foundation

// MARK: - SignInModulePresenter Class
final class SignInPresenter: Presenter {
  override func viewDidLoad() {
    super.viewDidLoad()
    SignIn.InputFields.allCases.forEach {
      viewController.showPlaceholder(for: $0, hidden: false)
    }
  }
}

// MARK: - SignInModulePresenter API
extension SignInPresenter: SignInPresenterApi {
  func handleSignUpAction() {
    router.routeToSignUp()
  }
  
  func handleHideAction() {
    router.dismiss()
  }
  
  func handleRestorePasswordAction() {
    router.routeToRestorePasswordModule()
  }
  
  func handleSignInAction() {
    viewController.presentDimOverlayViewHidden(false)
    interactor.performSignInWithCurrentValues()
  }
  
  func presentLoginFailed() {
    viewController.presentDimOverlayViewHidden(true)
  }
  
  func presentSuccessfulLoginWith(_ email: String, account: SignInAccount) {
    viewController.presentDimOverlayViewHidden(true)
    switch account {
    case .verifiedAccount(_):
      router.routeToMainTabbar()
    case .notVerifiedAccount(let notVerifiedAccount):
      let shouldConfirmEmail = !notVerifiedAccount.accountVerificationState.isMailVerified
      let shouldConfirmPhone = !notVerifiedAccount.accountVerificationState.isPhoneVerified
      
      guard shouldConfirmEmail || shouldConfirmPhone else {
        router.routeToMainTabbar()
        return
      }
      
      router.routeToConfirmation(email: email, shouldConfirmEmail: shouldConfirmEmail, shouldConfirmPhone: shouldConfirmPhone)
    }
  }
 
  func handleValueChangedForField(_ field: SignIn.InputFields, value: String) {
    viewController.showPlaceholder(for: field, hidden: !value.isEmpty)
    interactor.updateValueFor(field, value: value)
  }
}

// MARK: - SignInModule Viper Components
fileprivate extension SignInPresenter {
    var viewController: SignInViewControllerApi {
        return _viewController as! SignInViewControllerApi
    }
    var interactor: SignInInteractorApi {
        return _interactor as! SignInInteractorApi
    }
    var router: SignInRouterApi {
        return _router as! SignInRouterApi
    }
}
