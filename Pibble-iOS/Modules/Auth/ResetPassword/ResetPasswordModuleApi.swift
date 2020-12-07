//
//  ResetPasswordModuleApi.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 26.06.2018.
//Copyright © 2018 com.kazai. All rights reserved.
//

//MARK: - ResetPasswordModuleRouter API
protocol ResetPasswordRouterApi: RouterProtocol {
  func routeToPasswordResetSuccess()
}

//MARK: - ResetPasswordModuleView API
protocol ResetPasswordViewControllerApi: ViewControllerProtocol {
  func showPlaceholder(for field: ResetPassword.InputFields, hidden: Bool)
  func setInteractionEnabled(_ enabled: Bool)
}

//MARK: - ResetPasswordModulePresenter API
protocol ResetPasswordPresenterApi: PresenterProtocol {
  func handleResetPasswordAction()
  func presentSuccessfulPasswordReset()
  func presentPasswordResetFail()
  
  
  func handleHideAction()
  func handleValueChangedForField(_ field: ResetPassword.InputFields, value: String)
}

//MARK: - ResetPasswordModuleInteractor API
protocol ResetPasswordInteractorApi: InteractorProtocol {
  func performResetPasswordWithCurrentValues()
  func updateValueFor(_ field: ResetPassword.InputFields, value: String)
}
