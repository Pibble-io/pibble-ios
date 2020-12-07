//
//  PropertyStoringProtocol.swift
//  Pibble
//
//  Created by Kazakov Sergey on 13.01.2019.
//  Copyright © 2019 com.kazai. All rights reserved.
//

import Foundation

protocol PropertyStoringProtocol {
//  associatedtype T
  
  func getAssociatedObject<T>(_ key: UnsafeRawPointer!, defaultValue: T) -> T
  func getAssociatedObject<T>(_ key: UnsafeRawPointer!) -> T?
  func setAssociatedObject<T>(_ key: UnsafeRawPointer!, value: T?)
}

extension PropertyStoringProtocol {
  func getAssociatedObject<T>(_ key: UnsafeRawPointer!, defaultValue: T) -> T {
    guard let value = objc_getAssociatedObject(self, key) as? T else {
      return defaultValue
    }
    return value
  }
  
  func getAssociatedObject<T>(_ key: UnsafeRawPointer!) -> T? {
    return objc_getAssociatedObject(self, key) as? T
  }
  
  func setAssociatedObject<T>(_ key: UnsafeRawPointer!, value: T?) {
    objc_setAssociatedObject(self, key, value, .OBJC_ASSOCIATION_RETAIN)
  }
}

/*
extension UICollectionViewLayoutAttributes: PropertyStoring {
  typealias T = Float
  
  private struct CustomProperties {
    static var zIndexForMovements = 0
  }
  
  var zIndexForMovements: Float {
    get {
      return getAssociatedObject(&CustomProperties.zIndexForMovements, defaultValue: Float(zIndex))
    }
    set {
      objc_setAssociatedObject(self, &CustomProperties.zIndexForMovements, newValue, .OBJC_ASSOCIATION_RETAIN)
    }
  }
}
*/
