//
//  RegistrationModuleInteractor.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 16.06.2018.
//Copyright © 2018 com.kazai. All rights reserved.
//

import Foundation 

// MARK: - RegistrationModuleInteractor Class
final class RegistrationInteractor: Interactor {
  fileprivate var fieldsDict: [Registration.InputFields: String] = [:]
  fileprivate var loginService: AuthServiceProtocol
  
  init(loginService: AuthServiceProtocol) {
    self.loginService = loginService
  }
}

// MARK: - RegistrationModuleInteractor API
extension RegistrationInteractor: RegistrationInteractorApi {
  var termsURL: URL {
    return PibbleAppEndpoints.termsUrl
  }
  
  var privacyPolicyURL: URL {
    return PibbleAppEndpoints.privacyPolicyUrl
  }
  
  func performSignUpWithCurrentValues() {
    if let error = checkAllValues(fieldsDict) {
      presenter.presentRegistrationFail()
      presenter.handleError(error)
      return
    }
    
    let signUpUser = Registration.SignUpUser()
    signUpUser.email = fieldsDict[.email]!
    signUpUser.password = fieldsDict[.password]!
    signUpUser.username = fieldsDict[.username]!

    loginService.signUp(user: signUpUser) { [weak self] res in
      guard let strongSelf = self else {
        return
      }

      switch res {
      case .success(let signUpAccount):
        strongSelf.presenter.presentSuccessfulRegistrationFor(signUpAccount, with: signUpUser.email)
      case .failure(let error):
        strongSelf.presenter.presentRegistrationFail()
        strongSelf.presenter.handleError(error)
      }
    }
  }
  
  func updateValueFor(_ field: Registration.InputFields, value: String) {
    fieldsDict[field] = value
    
    switch field {
    case .email:
      break
    case .username:
      if let validation = fieldsDict[.username]?.validateUsername() {
        presenter.presentUsernameValidation(validation)
      }
    case .password:
      if let validation = fieldsDict[.password]?.validatePassword() {
        presenter.presentPasswordValidation(validation)
      }
    }
  }
}

fileprivate extension RegistrationInteractor {
  func checkAllValues(_ dict: [Registration.InputFields: String]) -> Registration.SignUpError? {
    
    for field in Registration.InputFields.allCases {
      guard let _ = dict[field] else {
        return Registration.SignUpError.fieldError(field, .empty)
      }
    }
    
    return nil
  }
}

// MARK: - Interactor Viper Components Api
fileprivate extension RegistrationInteractor {
  var presenter: RegistrationPresenterApi {
      return _presenter as! RegistrationPresenterApi
  }
}


fileprivate extension String {
  func validatePassword() -> [Registration.PasswordRequirements: Bool] {
    var validationDict: [Registration.PasswordRequirements: Bool] = [:]
    validationDict[.minLength] = isLengthValid
    validationDict[.oneNumber] = hasNumber
    validationDict[.oneSpecialChar] = hasSpecialChar
    validationDict[.oneUppercaseChar] = hasUppercaseLetters
    return validationDict
  }
  
  var isLengthValid: Bool {
    return count >= 8
  }
  
  var isUsernameLengthValid: Bool {
    return count >= 6
  }
  
  var isAlphanumeric: Bool {
    return !isEmpty && range(of: "[^a-zA-Z0-9]", options: .regularExpression) == nil
  }
  
  var hasUppercaseLetters: Bool {
    let largeLetterRegEx  = ".*[A-Z]+.*"
    let largeLetterPredicate = NSPredicate(format:"SELF MATCHES %@", largeLetterRegEx)
    return largeLetterPredicate.evaluate(with: self)
  }
  
  var hasNumber: Bool {
    let numberRegEx  = ".*[0-9]+.*"
    let numberPredicate = NSPredicate(format:"SELF MATCHES %@", numberRegEx)
    return numberPredicate.evaluate(with: self)
  }
  
  var hasSpecialChar: Bool {
    let regex = ".*[^A-Za-z0-9].*"
    let specialCharPredicate = NSPredicate(format:"SELF MATCHES %@", regex)
    return specialCharPredicate.evaluate(with: self)
  }
  
  func validateUsername() -> [Registration.UsernameRequirements: Bool] {
    var validationDict: [Registration.UsernameRequirements: Bool] = [:]
    validationDict[.minLength] = isUsernameLengthValid
    validationDict[.allowedChars] = isAlphanumeric
    return validationDict
  }
}
