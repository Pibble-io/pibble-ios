//
//  UserDescriptionPickerModuleScope.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 12.11.2018.
//Copyright © 2018 com.kazai. All rights reserved.
//

import Foundation

enum UserDescriptionPicker {
  enum Inputs: String {
    case description = "description"
    case firstName = "first Name"
    case lastName = "last Name"
    case website = "website"
  }
  
  enum ValidationError: Error, PibbleErrorProtocol {
    case wrongURL
    case lengthLimit(Inputs, Int)
    case empty(Inputs)
    
    var description: String {
      switch self {
      case .wrongURL:
        return Strings.Errors.wrongURL.localize()
      case .lengthLimit(let input, let limit):
        return Strings.Errors.lengthLimit.localize(values: input.rawValue.capitalized, "\(limit)")
      case .empty(let input):
        return Strings.Errors.empty.localize(value: input.rawValue.capitalized)
      }
    }
  }
  
  struct UserProfile: UserProfileProtocol {
    let userProfileDescription: String
    
    let userProfileFirstName: String
    
    let userProfileLastName: String
    
    let userProfileSiteName: String
  }
}


extension UserDescriptionPicker {
  enum Strings {
    enum Errors: String, LocalizedStringKeyProtocol {
      case wrongURL = "Incorrect website URL"
      case lengthLimit = "% is out of % characters limit"
      case empty = "% is empty"
    }
  }
}
