//
//  RegistrationModuleApi.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 16.06.2018.
//Copyright © 2018 com.kazai. All rights reserved.
//

import Foundation

//MARK: - RegistrationModuleRouter API
protocol RegistrationRouterApi: RouterProtocol {
  func routeToSignInModule()
  func routeToVerifyEmailModule(_ email: String)

  func routeToExternalLinkWithUrl(_ url: URL, title: String)
}

//MARK: - RegistrationModuleView API
protocol RegistrationViewControllerApi: ViewControllerProtocol {
  func presentDimOverlayViewHidden(_ hidden: Bool)
  
  func showPlaceholder(for field: Registration.InputFields, hidden: Bool)
  
  func showPasswordValidation(_ validationResult: [Registration.PasswordRequirements: Bool])
  
  func showUsernameValidation(_ validationResult: [Registration.UsernameRequirements: Bool])
}

//MARK: - RegistrationModulePresenter API
protocol RegistrationPresenterApi: PresenterProtocol {
  func handleTermsAction()
  func handlePrivacyPolicyAction()
  func handleSignUpAction()
  func presentSuccessfulRegistrationFor(_ account: SignUpAccount, with email: String)
  func handleLoginAction()
  
  func handleValueChangedForField(_ field: Registration.InputFields, value: String)
  
  func presentRegistrationFail()
  
  func presentUsernameValidation(_ validationResult: [Registration.UsernameRequirements: Bool])
  
  func presentPasswordValidation(_ validationResult: [Registration.PasswordRequirements: Bool])
}

//MARK: - RegistrationModuleInteractor API
protocol RegistrationInteractorApi: InteractorProtocol {
  var termsURL: URL { get }
  var privacyPolicyURL: URL { get }
  
  func updateValueFor(_ field: Registration.InputFields, value: String)
  
  func performSignUpWithCurrentValues()
}


