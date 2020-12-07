//
//  DecodingTarget.swift
//  Pibble
//
//  Created by Kazakov Sergey on 16.06.2018.
//  Copyright © 2018 com.kazai. All rights reserved.
//

import Foundation

protocol CoderConfigProtocol {
  static var responseDecoder: JSONDecoder { get }
  static var parametersEncoder: JSONEncoder  { get }
}

