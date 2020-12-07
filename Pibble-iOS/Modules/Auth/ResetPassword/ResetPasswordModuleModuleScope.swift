//
//  ResetPasswordModuleModuleScope.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 26.06.2018.
//Copyright © 2018 com.kazai. All rights reserved.
//

import Foundation

enum ResetPassword {
  enum InputFields: String {
    case password
    case passwordConfirm
    
    static let allCases: [InputFields] = [ .password, .passwordConfirm]
    
    var title: String {
      switch self {
      case .password:
        return Strings.Fields.password.localize()
      case .passwordConfirm:
        return Strings.Fields.passwordConfirm.localize()
      }
    }
  }
  
  struct ChangePassword: ChangePasswordProtocol {
    let code: String
    let password: String
  }

  
  enum ResetPasswordError: Error, PibbleErrorProtocol {
    case serverError(Error)
    case fieldError(InputFields, ResetPasswordFieldError)
    
    var description: String {
      switch self {
      case .serverError(let err):
        return err.localizedDescription
      case .fieldError(let field, let err):
        return "\(err.description): \(field.title)"
        
      }
    }
  }
  
  enum ResetPasswordFieldError: Error, PibbleErrorProtocol {
    case empty
    case notMatching
    
    var description: String {
      switch self {
      case .empty:
        return Strings.Errors.empty.localize()
      case .notMatching:
        return Strings.Errors.notMatching.localize()
      }
    }
  }
    
}


extension ResetPassword {
  enum Strings {
    enum Fields: String, LocalizedStringKeyProtocol {
      case password = "password"
      case passwordConfirm = "passwordConfirm"
    }
    
    enum Errors: String, LocalizedStringKeyProtocol {
      case empty = "Field is empty"
      case notMatching = "Field does not match"
    }
  }
}
