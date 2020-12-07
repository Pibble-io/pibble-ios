//
//  DeviceOrientationNotifications.swift
//  Pibble
//
//  Created by Kazakov Sergey on 12.07.2018.
//  Copyright © 2018 com.kazai. All rights reserved.
//

import UIKit

protocol DeviceOrientationNotificationsDelegateProtocol: class {
  func deviceOrientationDidChangeTo(_ orientation: UIDeviceOrientation)
}

extension UIViewController {
  func subscribeDeviceOrientationNotications() {
    NotificationCenter.default.addObserver(self, selector: #selector(deviceOrientationDidChange(noti:)), name: UIDevice.orientationDidChangeNotification, object: nil)
  }
  
  func unsubscribeDeviceOrientationNotications() {
    NotificationCenter.default.removeObserver(self)
  }
  
  @objc func deviceOrientationDidChange(noti: Notification) {
    guard let delegate = (self as? DeviceOrientationNotificationsDelegateProtocol) else {
      return
    }
    delegate.deviceOrientationDidChangeTo(UIDevice.current.orientation)
  }



}
