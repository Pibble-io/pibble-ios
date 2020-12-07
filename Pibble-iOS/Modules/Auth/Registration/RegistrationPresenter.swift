//
//  RegistrationModulePresenter.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 16.06.2018.
//Copyright © 2018 com.kazai. All rights reserved.
//

import Foundation

// MARK: - RegistrationModulePresenter Class
final class RegistrationPresenter: Presenter {
  override func viewDidLoad() {
    super.viewDidLoad()
    viewController.presentDimOverlayViewHidden(true)
    Registration.InputFields.allCases.forEach {
      viewController.showPlaceholder(for: $0, hidden: false)
    }
  }
}

// MARK: - RegistrationModulePresenter API
extension RegistrationPresenter: RegistrationPresenterApi {
  func presentUsernameValidation(_ validationResult: [Registration.UsernameRequirements : Bool]) {
    viewController.showUsernameValidation(validationResult)
  }
  
  func handlePrivacyPolicyAction() {
    router.routeToExternalLinkWithUrl(interactor.privacyPolicyURL, title: Registration.Strings.Links.privacyPolicy.localize())
  }
  
  func handleTermsAction() {
    router.routeToExternalLinkWithUrl(interactor.termsURL, title: Registration.Strings.Links.terms.localize())
  }
  
  func handleLoginAction() {
    router.routeToSignInModule()
  }
  
  func presentSuccessfulRegistrationFor(_ account: SignUpAccount, with email: String) {
     viewController.presentDimOverlayViewHidden(true)
     router.routeToVerifyEmailModule(email)
  }
  
  func handleValueChangedForField(_ field: Registration.InputFields, value: String) {
    viewController.showPlaceholder(for: field, hidden: !value.isEmpty)
    interactor.updateValueFor(field, value: value)
  }
  
  func handleSignUpAction() {
    viewController.presentDimOverlayViewHidden(false)
    interactor.performSignUpWithCurrentValues()
  }
  
  func presentRegistrationFail() {
    viewController.presentDimOverlayViewHidden(true)
  }
  
  func presentPasswordValidation(_ validationResult: [Registration.PasswordRequirements: Bool]) {
    viewController.showPasswordValidation(validationResult)
  }
}

// MARK: - RegistrationModule Viper Components
fileprivate extension RegistrationPresenter {
    var viewController: RegistrationViewControllerApi {
        return _viewController as! RegistrationViewControllerApi
    }
    var interactor: RegistrationInteractorApi {
        return _interactor as! RegistrationInteractorApi
    }
    var router: RegistrationRouterApi {
        return _router as! RegistrationRouterApi
    }
}
