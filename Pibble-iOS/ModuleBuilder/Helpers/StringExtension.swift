//
//  StringExtension.swift
//  Pibble
//
//  Created by Kazakov Sergey on 15.06.2018.
//  Copyright © 2018 com.kazai. All rights reserved.
//

import Foundation

extension String {
  fileprivate var first: String {
    return String(prefix(1))
  }
  var uppercasedFirst: String {
    return first.uppercased() + String(dropFirst())
  }
}

