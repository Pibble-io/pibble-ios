//
//  LoginService.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 14.06.2018.
//  Copyright © 2018 com.kazai. All rights reserved.
//

import Foundation

class AuthService: AuthServiceProtocol {
  var isLoggedIn: Bool {
    return false
  }
  
  func login(username: String, password: String, complete: ((Bool?, PibbleError?) -> ())?) {
    
  }
}
