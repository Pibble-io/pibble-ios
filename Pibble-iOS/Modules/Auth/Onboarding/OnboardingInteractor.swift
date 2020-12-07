//
//  OnboardingInteractor.swift
//  Pibble-iOS
//
//  Created by Sergey Kazakov on 04/07/2019.
//Copyright © 2019 com.kazai. All rights reserved.
//

import Foundation 

// MARK: - OnboardingInteractor Class
final class OnboardingInteractor: Interactor {
  fileprivate let authService: AuthServiceProtocol
  
  init(authService: AuthServiceProtocol) {
    self.authService = authService
  }
}

// MARK: - OnboardingInteractor API
extension OnboardingInteractor: OnboardingInteractorApi {
  func setOnboardingFinished() {
    authService.presentedOnboarding = true
  }
}

// MARK: - Interactor Viper Components Api
private extension OnboardingInteractor {
  var presenter: OnboardingPresenterApi {
    return _presenter as! OnboardingPresenterApi
  }
}
