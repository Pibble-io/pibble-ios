//
//  RestorePasswordMethodModuleInteractor.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 22.06.2018.
//Copyright © 2018 com.kazai. All rights reserved.
//

import Foundation 

// MARK: - RestorePasswordMethodModuleInteractor Class
final class RestorePasswordMethodInteractor: Interactor {
  fileprivate let accountProfileService: AccountProfileServiceProtocol
  fileprivate let authService: AuthServiceProtocol
  let purpose: RestorePasswordMethod.Purpose
  
  init(accountProfileService: AccountProfileServiceProtocol, authService: AuthServiceProtocol, purpose: RestorePasswordMethod.Purpose) {
    self.accountProfileService = accountProfileService
    self.authService = authService
    self.purpose = purpose
  }
}

// MARK: - RestorePasswordMethodModuleInteractor API
extension RestorePasswordMethodInteractor: RestorePasswordMethodInteractorApi {
  func performSMSResetCodeRequest() {
    accountProfileService.getProfile { [weak self] in
      guard let strongSelf = self else {
        return
      }
      
      switch $0 {
      case .success(let accountProfile):
        guard let userPhone = accountProfile.userPhone,
          let countryId = accountProfile.userPhoneCountry?.identifier else {
            strongSelf.presenter.presentSendingRequestFinished()
            strongSelf
              .presenter
              .handleError(RestorePasswordMethod.RestorePasswordMethodError.noVerifiedPhoneNumber)
            return
        }
        
        let phone = UserPhoneNumber(countryId: countryId,
                                    phone: userPhone)
        strongSelf.authService.sendResetPinCodeTo(phone, complete: { [weak self] in
          
          guard let strongSelf = self else {
            return
          }
          strongSelf.presenter.presentSendingRequestFinished()
          
          if let error = $0 {
            strongSelf.presenter.handleError(error)
            return
          }
          
          strongSelf.presenter.presentSMSResetCodeSentSuccessTo(phone)
        })
      case .failure(let error):
        strongSelf.presenter.handleError(error)
      }
    }
  }
  
  func performEmailResetCodeRequest() {
    accountProfileService.getProfile { [weak self] in
      guard let strongSelf = self else {
        return
      }
      
      switch $0 {
      case .success(let accountProfile):
        let email = ResetPasswordEmail(email: accountProfile.accountProfileEmail)
        strongSelf.authService.sendResetPinCodeTo(email, complete: { [weak self] in
          guard let strongSelf = self else {
            return
          }
          strongSelf.presenter.presentSendingRequestFinished()
          
          if let error = $0 {
            strongSelf.presenter.handleError(error)
            return
          }
          
          strongSelf.presenter.presentEmailResetCodeSentSuccessTo(email)
        })
      case .failure(let error):
        strongSelf.presenter.handleError(error)
      }
    }
  }
}

// MARK: - Interactor Viper Components Api
private extension RestorePasswordMethodInteractor {
    var presenter: RestorePasswordMethodPresenterApi {
        return _presenter as! RestorePasswordMethodPresenterApi
    }
}
