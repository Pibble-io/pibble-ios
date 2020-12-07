//
//  ResetPasswordModuleInteractor.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 26.06.2018.
//Copyright © 2018 com.kazai. All rights reserved.
//

import Foundation 

// MARK: - ResetPasswordModuleInteractor Class
final class ResetPasswordInteractor: Interactor {
  fileprivate let code: String
  fileprivate var fieldsDict: [ResetPassword.InputFields: String] = [:]
  fileprivate var loginService: AuthServiceProtocol
  
  init(loginService: AuthServiceProtocol, code: String) {
    self.code = code
    self.loginService = loginService
  }
 
}

// MARK: - ResetPasswordModuleInteractor API

extension ResetPasswordInteractor: ResetPasswordInteractorApi {
  
  func performResetPasswordWithCurrentValues() {
    if let error = checkAllValues(fieldsDict) {
      presenter.presentPasswordResetFail()
      presenter.handleError(error)
      return
    }
    
    let password = fieldsDict[.password]!
    let changePassword = ResetPassword.ChangePassword(code: code, password: password)
    
    loginService.changePassword(changePassword) { [weak self] in
      guard let strongSelf = self else {
        return
      }
      
      guard let error = $0 else {
        strongSelf.presenter.presentSuccessfulPasswordReset()
        return
      }
      strongSelf.presenter.presentPasswordResetFail()
      strongSelf.presenter.handleError(error)
    }
  }
  
  func updateValueFor(_ field: ResetPassword.InputFields, value: String) {
    fieldsDict[field] = value
  }
}

// MARK: - Interactor Viper Components Api

private extension ResetPasswordInteractor {
    var presenter: ResetPasswordPresenterApi {
        return _presenter as! ResetPasswordPresenterApi
    }
}

fileprivate extension ResetPasswordInteractor {
  func checkAllValues(_ dict: [ResetPassword.InputFields: String]) -> ResetPassword.ResetPasswordError? {
    
    for field in ResetPassword.InputFields.allCases {
      guard let _ = dict[field] else {
        return ResetPassword.ResetPasswordError.fieldError(field, .empty)
      }
    }
    
    guard dict[.password] == dict[.passwordConfirm] else {
       return ResetPassword.ResetPasswordError.fieldError(.passwordConfirm, .notMatching)
    }
    
    return nil
  }
}
