//
//  DeviceScreenLayoutType.swift
//  Pibble
//
//  Created by Kazakov Sergey on 25.07.2018.
//  Copyright © 2018 com.kazai. All rights reserved.
//

import UIKit

protocol DeviceDependentValue {
  static var iPhone4: CGFloat { get }
  static var iPhone5: CGFloat  { get }
  static var iPhonePlus: CGFloat  { get }
  static var iPhoneX: CGFloat  { get }
  static var iPhone: CGFloat  { get }
  static var iPad: CGFloat  { get }
  static var iPadPro10: CGFloat  { get }
  static var iPadPro12: CGFloat  { get }
}

extension DeviceDependentValue {
  static func valueFor(_ layoutType: DeviceScreenLayoutType) -> CGFloat {
    switch layoutType {
    case .iPhone4:
      return iPhone4
    case .iPhone5:
      return iPhone5
    case .iPhone:
      return iPhone
    case .iPhonePlus:
      return iPhonePlus
    case .iPhoneX:
      return iPhoneX
    case .iPad:
      return iPad
    case .iPad10:
      return iPadPro10
    case .iPad12:
      return iPadPro12
    }
  }
}

enum DeviceScreenLayoutType {
  case iPhone4
  case iPhone5
  case iPhone
  case iPhonePlus
  case iPhoneX
  case iPad
  case iPad10
  case iPad12
  
  var isiPad: Bool {
    switch self {
    case .iPhone4:
      return false
    case .iPhone5:
      return false
    case .iPhone:
      return false
    case .iPhonePlus:
      return false
    case .iPhoneX:
      return false
    case .iPad:
      return true
    case .iPad10:
      return true
    case .iPad12:
      return true
    }
  }
  
  var name: String {
    return String(describing: self)
  }
  
  init() {
    let screenHeight  = Int(UIScreen.main.fixedCoordinateSpace.bounds.height)
    self.init(screenHeight: screenHeight)
  }
  
  fileprivate init(screenHeight: Int) {
    guard UIDevice.current.userInterfaceIdiom != .phone else {
      guard screenHeight != 480 else {
        self = .iPhone4
        return
      }
      guard screenHeight != 568 else {
        self = .iPhone5
        return
      }
      
      guard screenHeight != 667 else {
        self = .iPhone
        return
      }
      guard screenHeight != 736 else {
        self = .iPhonePlus
        return
      }
      
      guard screenHeight != 812 else {
        self = .iPhoneX
        return
      }
      
      self = .iPhone
      return
      
    }
    
    guard screenHeight != 1024 else {
      self = .iPad
      return
    }
    
    guard screenHeight != 1112 else {
      self = .iPad10
      return
    }
    
    guard screenHeight != 1366 else {
      self = .iPad12
      return
    }
    
    self = .iPad
    return
  }
  
}
