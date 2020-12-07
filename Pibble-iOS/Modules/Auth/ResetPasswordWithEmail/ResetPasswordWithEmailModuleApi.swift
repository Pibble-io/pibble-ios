//
//  ResetPasswordWithEmailModuleApi.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 22.06.2018.
//Copyright © 2018 com.kazai. All rights reserved.
//

//MARK: - ResetPasswordWithEmailModuleRouter API
protocol ResetPasswordWithEmailRouterApi: RouterProtocol {
  func routeToPasswordResetSendModule(email: ResetPasswordEmailProtocol)
}

//MARK: - ResetPasswordWithEmailModuleView API
protocol ResetPasswordWithEmailViewControllerApi: ViewControllerProtocol {
  func showPlaceholderForEmail(hidden: Bool)
  func setInteractionEnabled(_ enabled: Bool)
}

//MARK: - ResetPasswordWithEmailModulePresenter API
protocol ResetPasswordWithEmailPresenterApi: PresenterProtocol {
  func handleEmailValueChanged(_ value: String)
  func handleResetPasswordAction()
  
  func presentSuccessfulSendPasswordResetTo(_ email: ResetPasswordEmailProtocol)
  func presentSendPasswordResetFailed()
  
  func handleHideAction()
}

//MARK: - ResetPasswordWithEmailModuleInteractor API
protocol ResetPasswordWithEmailInteractorApi: InteractorProtocol {
  func setEmail(_ email: String)
  func performResetPasswordWithCurentValues()
}
