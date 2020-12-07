//
//  VerifyCodeModuleDataContainer.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 20.06.2018.
//Copyright © 2018 com.kazai. All rights reserved.
//

import Foundation

enum VerifyCode {
  enum Purpose {
    case phoneVerification(UserPhoneNumberProtocol)
    case initialEmailVerification(String)
    case forcedEmailVerification(email: String, phoneVerificationNeeded: Bool)
  }
  
}
