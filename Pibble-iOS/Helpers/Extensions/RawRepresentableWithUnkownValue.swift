//
//  RawRepresentableWithUnkownValue.swift
//  Pibble
//
//  Created by Sergey Kazakov on 26/06/2019.
//  Copyright © 2019 com.kazai. All rights reserved.
//

import Foundation

protocol RawRepresentableWithUnkownValue: RawRepresentable, CaseIterable where RawValue: Equatable {
  static var unknownValue: Self { get }
}

extension RawRepresentableWithUnkownValue {
  init(rawValue: RawValue) {
    self = Self.allCases.first { $0.rawValue == rawValue} ?? Self.unknownValue
  }
}
