//
//  RegistrationModuleDataContainer.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 16.06.2018.
//Copyright © 2018 com.kazai. All rights reserved.
//

import Foundation

enum Registration {
  class SignUpUser: SignUpUserProtocol {
    var email: String  = ""
    var username: String = ""
    var password: String = ""
  }

  enum PasswordRequirements {
    case oneSpecialChar
    case oneUppercaseChar
    case oneNumber
    case minLength
  }
  
  enum UsernameRequirements {
    case allowedChars
    case minLength
  }

  
  enum InputFields: String {
    case email
    case username
    case password
    
    static let allCases: [InputFields] = [ .email, .username, .password]
    
    var title: String {
      switch self {
      case .email:
        return Strings.InputFields.email.localize()
      case .username:
        return Strings.InputFields.username.localize()
      case .password:
        return Strings.InputFields.password.localize()
      }
    }
  }
  
  enum SignUpError: Error, PibbleErrorProtocol {
    case serverError(Error)
    case fieldError(InputFields, SignUpFieldError)
    
    var description: String {
      switch self {
      case .serverError(let err):
        return err.localizedDescription
      case .fieldError(let field, let err):
        return "\(err.description): \(field.title)"
        
      }
    }
  }
  
  enum SignUpFieldError: Error, PibbleErrorProtocol {
    case empty
    
    var description: String {
      switch self {
      case .empty:
        return Strings.Errors.empty.localize()
      }
    }
  }
}

extension Registration {
  enum Strings {
    enum Errors: String, LocalizedStringKeyProtocol {
      case empty = "Field is empty"
    }
    
    enum InputFields: String, LocalizedStringKeyProtocol {
      case email = "email"
      case username = "username"
      case password = "password"
    }
    
    enum Links: String, LocalizedStringKeyProtocol {
      case terms = "Terms of Use"
      case privacyPolicy = "Privacy Policy"
    }
  }
}
