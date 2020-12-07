//
//  OnboardingModuleApi.swift
//  Pibble-iOS
//
//  Created by Sergey Kazakov on 04/07/2019.
//Copyright © 2019 com.kazai. All rights reserved.
//

//MARK: - OnboardingRouter API
protocol OnboardingRouterApi: RouterProtocol {
  func routeToSignUpModule()
}

//MARK: - OnboardingView API
protocol OnboardingViewControllerApi: ViewControllerProtocol {
}

//MARK: - OnboardingPresenter API
protocol OnboardingPresenterApi: PresenterProtocol {
  func handeFinishOnboardingAction()
}

//MARK: - OnboardingInteractor API
protocol OnboardingInteractorApi: InteractorProtocol {
  func setOnboardingFinished()
}
