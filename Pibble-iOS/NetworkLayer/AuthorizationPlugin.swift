//
//  AuthorizationPlugin.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 14.06.2018.
//  Copyright © 2018 com.kazai. All rights reserved.
//

import Foundation
import Moya

enum AuthTokenType {
  case access
  case refreshAccessToken
  case signUpToken
  case refreshSignUpToken
  case none
}

struct AuthPlugin: PluginType {
  let tokenStorage: TokenStorageServiceProtocol
  
  func prepare(_ request: URLRequest, target: TargetType) -> URLRequest {
    guard let target = target as? SecuredEndpoint else {
      return request
    }
    
    let neededToken: String?
    
    switch target.requiredAuthTokenType {
    case .access:
      neededToken = tokenStorage.getLastPibbleTargetAccessToken()
    case .signUpToken:
      neededToken = tokenStorage.getLastPibbleTargetSignUpToken()
    case .refreshAccessToken:
      neededToken = tokenStorage.getLastPibbleTargetRefreshToken()
    case .refreshSignUpToken:
      neededToken = tokenStorage.getLastPibbleTargetSignUpRefreshToken()
    case .none:
      neededToken = nil
      return request
    }
    
    guard let token = neededToken else {
      return request
    }
    
    var request = request
    request.addValue("Bearer " + token, forHTTPHeaderField: "Authorization")
    return request
  }
}
