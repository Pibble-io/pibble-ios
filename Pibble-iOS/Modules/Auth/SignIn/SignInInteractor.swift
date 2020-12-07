//
//  SignInModuleInteractor.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 21.06.2018.
//Copyright © 2018 com.kazai. All rights reserved.
//

import Foundation 

// MARK: - SignInModuleInteractor Class
final class SignInInteractor: Interactor {
  fileprivate var fieldsDict: [SignIn.InputFields: String] = [:]
  fileprivate let loginService: AuthServiceProtocol
  fileprivate let accountProfileService: AccountProfileServiceProtocol
  
  init(loginService: AuthServiceProtocol, accountProfileService: AccountProfileServiceProtocol) {
    self.loginService = loginService
    self.accountProfileService = accountProfileService
  }
}

// MARK: - SignInModuleInteractor API
extension SignInInteractor: SignInInteractorApi {
  func performSignInWithCurrentValues() {
    if let error = checkAllValues(fieldsDict) {
      presenter.presentLoginFailed()
      presenter.handleError(error)
      return
    }
    
    let email = fieldsDict[.login]!
    let password = fieldsDict[.password]!
    
    let user = SignIn.SignInUser(login: email, password: password)
    
    loginService.signIn(user: user) { [weak self] res in
      guard let strongSelf = self else {
        return
      }
      
      switch res {
      case .success(let signInAccount):
        self?.presenter.presentSuccessfulLoginWith(email, account: signInAccount)
      case .failure(let error):
        strongSelf.presenter.presentLoginFailed()
        strongSelf.presenter.handleError(error)
      }
    }
  }
  
  //  fileprivate func checkIfPhoneAttached() {
  //    accountProfileService.getProfile { [weak self] in
  //      guard let strongSelf = self else {
  //        return
  //      }
  //
  //      switch $0 {
  //      case .success(let profile):
  //        strongSelf.presenter.handleSuccessfulLoginWith(profile: profile, needsEmailConfirmation: !profile.isUserEmailVerified, needsPhoneConfirmation: !profile.isUserPhoneVerified)
  //      case .failure(let error):
  //        strongSelf.presenter.handleError(error)
  //      }
  //    }
  //  }
  //
  func updateValueFor(_ field: SignIn.InputFields, value: String) {
    fieldsDict[field] = value
  }
}

fileprivate extension SignInInteractor {
  func checkAllValues(_ dict: [SignIn.InputFields: String]) -> SignIn.SignInError? {
    for field in SignIn.InputFields.allCases {
      guard let _ = dict[field] else {
        return SignIn.SignInError.fieldError(field, .empty)
      }
    }
    
    return nil
  }
}

// MARK: - Interactor Viper Components Api
private extension SignInInteractor {
  var presenter: SignInPresenterApi {
    return _presenter as! SignInPresenterApi
  }
}
