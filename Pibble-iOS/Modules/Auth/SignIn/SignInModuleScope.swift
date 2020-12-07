//
//  SignInModuleDataContainer.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 21.06.2018.
//Copyright © 2018 com.kazai. All rights reserved.
//

import Foundation

enum SignIn {
  struct SignInUser: SignInUserProtocol {
    let login: String
    let password: String
  }
  
  enum InputFields: String {
    case login
    case password
    
    static let allCases: [InputFields] = [ .login, .password]
    
    var title: String {
      switch self {
      case .login:
        return Strings.InputFields.login.localize()
      case .password:
        return Strings.InputFields.password.localize()
      }
    }
  }
  
  enum SignInError: Error, PibbleErrorProtocol {
    case serverError(Error)
    case fieldError(InputFields, SignInFieldError)
    
    var description: String {
      switch self {
      case .serverError(let err):
        return err.localizedDescription
      case .fieldError(let field, let err):
        return "\(err.description): \(field.title)"
        
      }
    }
  }
  
  enum SignInFieldError: Error, PibbleErrorProtocol {
    case empty
    
    var description: String {
      switch self {
      case .empty:
        return Strings.Errors.empty.localize()
      }
    }
  }
}

extension SignIn {
  enum Strings {
    enum InputFields: String, LocalizedStringKeyProtocol {
      case login = "login"
      case password = "password"
    }
    
    enum Errors: String, LocalizedStringKeyProtocol {
      case empty = "Field is empty"
    }
  }
}
