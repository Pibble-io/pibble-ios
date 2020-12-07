//
//  ResetPasswordSuccessModuleApi.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 27.06.2018.
//Copyright © 2018 com.kazai. All rights reserved.
//

//MARK: - ResetPasswordSuccessModuleRouter API
protocol ResetPasswordSuccessRouterApi: RouterProtocol {
  func routeToLogin()
}

//MARK: - ResetPasswordSuccessModuleView API
protocol ResetPasswordSuccessViewControllerApi: ViewControllerProtocol {
}

//MARK: - ResetPasswordSuccessModulePresenter API
protocol ResetPasswordSuccessPresenterApi: PresenterProtocol {
  func handleLoginAction()
}

//MARK: - ResetPasswordSuccessModuleInteractor API
protocol ResetPasswordSuccessInteractorApi: InteractorProtocol {
}
