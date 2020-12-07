//
//  ResetPasswordWithEmailModuleInteractor.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 22.06.2018.
//Copyright © 2018 com.kazai. All rights reserved.
//

import Foundation 

// MARK: - ResetPasswordWithEmailModuleInteractor Class
final class ResetPasswordWithEmailInteractor: Interactor {
  fileprivate var currentEmail: String = ""
  
  fileprivate let loginService: AuthServiceProtocol
  
  init(loginService: AuthServiceProtocol) {
    self.loginService = loginService
  }
}

// MARK: - ResetPasswordWithEmailModuleInteractor API

extension ResetPasswordWithEmailInteractor: ResetPasswordWithEmailInteractorApi {
  
  func performResetPasswordWithCurentValues() {
    let email = ResetPasswordEmail(email: currentEmail)
    presenter.presentSuccessfulSendPasswordResetTo(email)
//    loginService.sendResetPasswordTo(email) { [weak self] in
//      if let error = $0 {
//        self?.presenter.presentSendPasswordResetFailed()
//        self?.presenter.handleError(error)
//        return
//      }
//      
//      self?.presenter.presentSuccessfulSendPasswordResetTo(email)
//    }
  }
  
  func setEmail(_ email: String) {
    self.currentEmail = email
  }
}

// MARK: - Interactor Viper Components Api
private extension ResetPasswordWithEmailInteractor {
    var presenter: ResetPasswordWithEmailPresenterApi {
        return _presenter as! ResetPasswordWithEmailPresenterApi
    }
}
