//
//  EncodableDictExtension.swift
//  Pibble
//
//  Created by Kazakov Sergey on 01.08.2018.
//  Copyright © 2018 com.kazai. All rights reserved.
//

import Foundation

extension Encodable {
  func toDictionary() -> [String: Any] {
    let encoder = JSONEncoder()
    return toDictionaryWith(encoder)
  }
  
  func toDictionaryWith(_ encoder: JSONEncoder) -> [String: Any] {
    guard let data = try? encoder.encode(self) else { return [:] }
    let encodedDictionary = (try? JSONSerialization.jsonObject(with: data, options: .allowFragments))
      .flatMap { $0 as? [String: Any] }
    
    guard let dict = encodedDictionary else {
      return [:]
    }
    
    return dict
  }
}
