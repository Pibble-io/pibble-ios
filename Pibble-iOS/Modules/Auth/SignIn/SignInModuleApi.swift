//
//  SignInModuleApi.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 21.06.2018.
//Copyright © 2018 com.kazai. All rights reserved.
//

//MARK: - SignInModuleRouter API
protocol SignInRouterApi: RouterProtocol {
  func routeToSignUp()
  func routeToMainTabbar()
  func routeToPhonePick()
  func routeToRestorePasswordModule()
  func routeToConfirmation(email: String, shouldConfirmEmail: Bool, shouldConfirmPhone: Bool)
}

//MARK: - SignInModuleView API
protocol SignInViewControllerApi: ViewControllerProtocol {
  func showPlaceholder(for field: SignIn.InputFields, hidden: Bool)
  
  func presentDimOverlayViewHidden(_ hidden: Bool)
}

//MARK: - SignInModulePresenter API
protocol SignInPresenterApi: PresenterProtocol {
  func handleRestorePasswordAction()
  func handleSignUpAction()
  func handleSignInAction()
  
  
  func handleHideAction()
  func handleValueChangedForField(_ field: SignIn.InputFields, value: String)
  
  func presentLoginFailed()
  func presentSuccessfulLoginWith(_ email: String, account: SignInAccount)
  
}

//MARK: - SignInModuleInteractor API
protocol SignInInteractorApi: InteractorProtocol {
  func performSignInWithCurrentValues()
  
  func updateValueFor(_ field: SignIn.InputFields, value: String)
}

