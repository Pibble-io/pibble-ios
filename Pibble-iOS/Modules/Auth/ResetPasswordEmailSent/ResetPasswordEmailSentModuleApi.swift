//
//  ResetPasswordEmailSentModuleApi.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 25.06.2018.
//Copyright © 2018 com.kazai. All rights reserved.
//

//MARK: - ResetPasswordEmailSentModuleRouter API
protocol ResetPasswordEmailSentRouterApi: RouterProtocol {
  func routeToVerifyCodeWith(_ email: ResetPasswordEmailProtocol)
}

//MARK: - ResetPasswordEmailSentModuleView API
protocol ResetPasswordEmailSentViewControllerApi: ViewControllerProtocol {
  
  func setEmailSentText(_ value: String)
}

//MARK: - ResetPasswordEmailSentModulePresenter API
protocol ResetPasswordEmailSentPresenterApi: PresenterProtocol {
  func handleNextStepAction()
}

//MARK: - ResetPasswordEmailSentModuleInteractor API
protocol ResetPasswordEmailSentInteractorApi: InteractorProtocol {
  
  var email: ResetPasswordEmailProtocol { get }
}
