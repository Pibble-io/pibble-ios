//
//  AuthorizedTargetType.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 14.06.2018.
//  Copyright © 2018 com.kazai. All rights reserved.
//

import Foundation
import Moya

protocol SecuredEndpoint: TargetType {
  var requiredAuthTokenType: AuthTokenType { get }
}


