//
//  KeyboardNotifications.swift
//  Pibble
//
//  Created by Kazakov Sergey on 17.06.2018.
//  Copyright © 2018 com.kazai. All rights reserved.
//

import UIKit

protocol KeyboardNotificationsDelegateProtocol: class {
  func keyBoardWillShowWithBottomInsets(_ bottomInsets: CGFloat, animationOptions: UIView.AnimationOptions, animationDuration: TimeInterval)
  func keyBoardWillHide(animationOptions: UIView.AnimationOptions, animationDuration: TimeInterval)
}

extension UIViewController {
  func subscribeKeyboardNotications() {
    NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
  }
  
  func unsubscribeKeyboardNotications() {
    NotificationCenter.default.removeObserver(self)
  }
  
  @objc func keyboardWillHide(notification: Notification) {
    guard let delegate = (self as? KeyboardNotificationsDelegateProtocol) else {
      return
    }
    
    guard let userInfo = notification.userInfo else {
      return
    }
    
    guard let animationCurveInt = (userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber)?.uintValue else {
      return
    }
    
    guard let duration = (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue else {
      return
    }
    
    let animationCurve = UIView.AnimationOptions(rawValue: animationCurveInt<<16)
    
    delegate.keyBoardWillHide(animationOptions: animationCurve, animationDuration: duration)
  }
  
  @objc func keyboardWillShow(notification: Notification) {
    guard let delegate = (self as? KeyboardNotificationsDelegateProtocol) else {
      return
    }
    
    guard let userInfo = notification.userInfo else {
      return
    }
    
    guard let keyboardFrame: CGRect = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
      return
    }
    
    guard let animationCurveInt = (userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber)?.uintValue else {
      return
    }
    
    guard let duration = (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue else {
      return
    }
    
    let animationCurve = UIView.AnimationOptions(rawValue: animationCurveInt<<16)
    delegate.keyBoardWillShowWithBottomInsets(keyboardFrame.size.height, animationOptions: animationCurve, animationDuration: duration)
  }
}

