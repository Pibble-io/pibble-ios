//
//  APIEndpoint.swift
//  Pibble
//
//  Created by Sergey Kazakov on 17/06/2019.
//  Copyright © 2019 com.kazai. All rights reserved.
//

import Foundation

protocol APIEndpoint {
  var baseURL: URL { get }
  var parametersEncoder: JSONEncoder { get }
  var responseDecoder: JSONDecoder { get }
  var headers: [String: String]? { get }
  var sampleData: Data { get }
}
