//
//  UIViewControllerNotificationExtension.swift
//  Pibble
//
//  Created by Kazakov Sergey on 14.01.2019.
//  Copyright © 2019 com.kazai. All rights reserved.
//

import UIKit

extension UIViewController {
  fileprivate static let viewDidAppearNotification: NSNotification.Name = NSNotification.Name("ViewControllerViewDidAppearGlobalNotification")

}

protocol UIViewControllerGlobalNotificationDelegateProtocol: class {
  func viewDidAppearGlobalNotificationHandler()
}

extension UIViewController {
  func fireViewDidAppearGlobalNotification() {
     NotificationCenter.default.post(name: UIViewController.viewDidAppearNotification, object: nil)
  }
  
  func subscribeToViewControllerGlobalNotications() {
    NotificationCenter.default.addObserver(self, selector: #selector(viewDidAppearGlobalNotification(notification:)), name: UIViewController.viewDidAppearNotification, object: nil)
  }
  
  func unsubscribeFromViewControllerGlobalNotications() {
    NotificationCenter.default.removeObserver(self, name: UIViewController.viewDidAppearNotification, object: nil)
  }
  
  @objc func viewDidAppearGlobalNotification(notification: Notification) {
    guard let delegate = (self as? UIViewControllerGlobalNotificationDelegateProtocol) else {
      return
    }
    DispatchQueue.main.async {
      delegate.viewDidAppearGlobalNotificationHandler()
    }
    
  }
}
