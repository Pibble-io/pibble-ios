//
//  ResetPasswordVerifyCodeModuleModuleScope.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 26.06.2018.
//Copyright © 2018 com.kazai. All rights reserved.
//

import Foundation

enum ResetPasswordVerifyCode {
  enum Method {
    case phoneNumber(UserPhoneNumberProtocol)
    case email(ResetPasswordEmailProtocol)
  }
  
  enum Purpose {
    case password(Method)
    case pinCode(Method)
  }
}
