//
//  ResetPasswordPhonePickModuleModuleScope.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 26.06.2018.
//Copyright © 2018 com.kazai. All rights reserved.
//

import Foundation

enum ResetPasswordPhonePick {
  enum PhonePickError: Error, PibbleErrorProtocol {
    case serverError(Error)
    case empty
    case wrongFormat
    case signUpUserIsNotSet
    case signUpCountryIsNotSet
    
    var description: String {
      switch self {
      case .serverError(let err):
        return err.localizedDescription
      case .empty:
        return Strings.Errors.empty.localize()
      case .wrongFormat:
        return Strings.Errors.wrongFormat.localize()
      case .signUpUserIsNotSet:
        return Strings.Errors.signUpUserIsNotSet.localize()
      case .signUpCountryIsNotSet:
        return Strings.Errors.signUpCountryIsNotSet.localize()
      }
    }
  }
  
  enum PickCountryButtonPresentation {
    case pickCodeButton
    case pickedCode
  }
}

extension ResetPasswordPhonePick {
  enum Strings {
    enum Errors: String, LocalizedStringKeyProtocol {
      case empty = "Phone field is empty"
      case wrongFormat = "Phone has wrong format"
      case signUpUserIsNotSet = "User is not set"
      case signUpCountryIsNotSet = "Country is not set"
    }
  }
}
