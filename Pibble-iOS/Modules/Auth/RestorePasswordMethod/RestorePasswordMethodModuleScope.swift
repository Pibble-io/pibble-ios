//
//  RestorePasswordMethodModuleDataContainer.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 22.06.2018.
//Copyright © 2018 com.kazai. All rights reserved.
//

import Foundation

enum RestorePasswordMethod {
  enum Purpose {
    case password
    case pinCode
  }
  
  enum RestorePasswordMethodError: Error, PibbleErrorProtocol {
    case noVerifiedPhoneNumber
    
    var description: String {
      switch self {
      case .noVerifiedPhoneNumber:
        return Strings.Errors.noVerifiedPhoneNumber.localize()
      }
    }
  }
}

extension RestorePasswordMethod {
  enum Strings {
    enum Password: String, LocalizedStringKeyProtocol {
      case information = "Select the contact details we should use to reset your password."
      case navBarTitle = "Forgot Password"
    }
    
    enum PinCode: String, LocalizedStringKeyProtocol {
      case information = "Select the contact details we should use to reset your PIN."
      case navBarTitle = "Forgot PIN"
    }
    
    enum Errors: String, LocalizedStringKeyProtocol {
      case noVerifiedPhoneNumber = "User has no verified phone number"
    }
  }
}
