//
//  OnboardingPresenter.swift
//  Pibble-iOS
//
//  Created by Sergey Kazakov on 04/07/2019.
//Copyright © 2019 com.kazai. All rights reserved.
//

import Foundation

// MARK: - OnboardingPresenter Class
final class OnboardingPresenter: Presenter {
}

// MARK: - OnboardingPresenter API
extension OnboardingPresenter: OnboardingPresenterApi {
  func handeFinishOnboardingAction() {
    interactor.setOnboardingFinished()
    router.routeToSignUpModule()
  }
}


// MARK: - Onboarding Viper Components
fileprivate extension OnboardingPresenter {
  var viewController: OnboardingViewControllerApi {
    return _viewController as! OnboardingViewControllerApi
  }
  var interactor: OnboardingInteractorApi {
    return _interactor as! OnboardingInteractorApi
  }
  var router: OnboardingRouterApi {
    return _router as! OnboardingRouterApi
  }
}
