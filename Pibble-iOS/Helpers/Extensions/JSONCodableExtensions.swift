//
//  JSONEncoderCodableExtensions.swift
//  Pibble
//
//  Created by Sergey Kazakov on 01/03/2019.
//  Copyright © 2019 com.kazai. All rights reserved.
//

import Foundation

extension JSONEncoder {
  func encodeJSONObject<T: Encodable>(_ value: T, options opt: JSONSerialization.ReadingOptions = []) throws -> Any {
    let data = try encode(value)
    return try JSONSerialization.jsonObject(with: data, options: opt)
  }
}

extension JSONDecoder {
  func decode<T: Decodable>(_ type: T.Type, withJSONObject object: Any, options opt: JSONSerialization.WritingOptions = []) throws -> T {
    let data = try JSONSerialization.data(withJSONObject: object, options: opt)
    return try decode(T.self, from: data)
  }
}
