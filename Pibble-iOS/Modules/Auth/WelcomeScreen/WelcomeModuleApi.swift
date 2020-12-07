//
//  WelcomeModuleApi.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 28.06.2018.
//Copyright © 2018 com.kazai. All rights reserved.
//

//MARK: - WelcomeModuleRouter API
protocol WelcomeScreenRouterApi: RouterProtocol {
  func routeToSwitchAccount()
  func routeToMainTabbar()
}

//MARK: - WelcomeModuleView API
protocol WelcomeScreenViewControllerApi: ViewControllerProtocol {
}

//MARK: - WelcomeModulePresenter API
protocol WelcomeScreenPresenterApi: PresenterProtocol {
  func handleContinueAction()
  func handleSwitchAccountAction()
}

//MARK: - WelcomeModuleInteractor API
protocol WelcomeScreenInteractorApi: InteractorProtocol {
}
