//
//  ScrollViewNotificationsExtension.swift
//  Pibble
//
//  Created by Kazakov Sergey on 13.01.2019.
//  Copyright © 2019 com.kazai. All rights reserved.
//

import UIKit

extension UIScrollView: PropertyStoringProtocol {
  fileprivate struct isTrackingOldValueOldValueCustomProperty {
    static var keyForRawPointer = 0
  }
  
  fileprivate struct InitialContentOffsetCustomProperty {
    static var keyForRawPointer = 0
  }
  
  fileprivate struct ContentOffsetObservationCustomProperty {
    static var keyForRawPointer = 0
  }
  
  fileprivate struct ContentOffsetOldValueCustomProperty {
    static var keyForRawPointer = 0
  }
  
  fileprivate var isTrackingOldValue: Bool {
    get {
      return getAssociatedObject(&isTrackingOldValueOldValueCustomProperty.keyForRawPointer, defaultValue: false)
    }
    
    set {
      setAssociatedObject(&isTrackingOldValueOldValueCustomProperty.keyForRawPointer, value: newValue)
    }
  }
  
  fileprivate var contentOffSetObservation: NSKeyValueObservation? {
    get {
      return getAssociatedObject(&ContentOffsetObservationCustomProperty.keyForRawPointer)
    }
    
    set {
      setAssociatedObject(&ContentOffsetObservationCustomProperty.keyForRawPointer, value: newValue)
    }
  }
  
  fileprivate var initialContentOffSet: CGPoint? {
    get {
      return getAssociatedObject(&InitialContentOffsetCustomProperty.keyForRawPointer)
    }
    
    set {
      setAssociatedObject(&InitialContentOffsetCustomProperty.keyForRawPointer, value: newValue)
    }
  }
  
  fileprivate var contentOffSetOldValue: CGPoint? {
    get {
      return getAssociatedObject(&ContentOffsetOldValueCustomProperty.keyForRawPointer)
    }
    
    set {
      setAssociatedObject(&ContentOffsetOldValueCustomProperty.keyForRawPointer, value: newValue)
    }
  }
}

extension UIScrollView {
  fileprivate func addContentOffsetChangesObserver(_ handler: @escaping ((current: CGPoint, oldValue: CGPoint, initial: CGPoint)) -> Void) {
   
    contentOffSetObservation = observe(\UIScrollView.contentOffset, options: .old) { [weak self] (object, observedChange) in
      let objectInteractionFlag =  object.isTracking
      
      if objectInteractionFlag && !object.isTrackingOldValue {
        self?.initialContentOffSet = object.contentOffset
      }
    
      
      self?.isTrackingOldValue = objectInteractionFlag
      self?.contentOffSetOldValue = object.contentOffset
      handler((object.contentOffset, observedChange.oldValue ?? object.contentOffset, object.initialContentOffSet ?? object.contentOffset))
    }
  }
  
  fileprivate func removeContentOffsetChangesObserver() {
    contentOffSetObservation = nil
  }
}

extension UIScrollView {
  static let scrollViewContentOffsetChanged: NSNotification.Name = NSNotification.Name("scrollViewContentOffsetChangedNotification")
  
  static let scrollViewContentOffsetKey = "scrollViewContentOffsetKey"
  static let scrollViewContentOffsetOldValueKey = "scrollViewContentOffsetOldValue"
  static let scrollViewInitialContentOffsetKey = "scrollViewInitialContentOffsetKey"
  
  var shouldFireContentOffsetChangesNotifications: Bool {
    get {
      return contentOffSetObservation != nil
    }
    
    set {
      guard newValue else {
        removeContentOffsetChangesObserver()
        return
      }
      
      addContentOffsetChangesObserver { newValue, oldValue, initialValue in
        var userInfo: [AnyHashable : Any] = [:]
        userInfo[UIScrollView.scrollViewContentOffsetKey] = newValue
        userInfo[UIScrollView.scrollViewContentOffsetOldValueKey] = oldValue
        userInfo[UIScrollView.scrollViewInitialContentOffsetKey] = initialValue
        
        NotificationCenter.default.post(name: UIScrollView.scrollViewContentOffsetChanged, object: nil, userInfo: userInfo)
      }
    }
  }
}

protocol ScrollViewContentOffsetNotificationsDelegateProtocol: class {
  func scrollViewDidChangeContentOffset(_ contentOffset: CGPoint, oldContentOffset: CGPoint, initialContentOffset: CGPoint)
}

extension UIViewController {
  func subscribeScrollViewNotications() {
    NotificationCenter.default.addObserver(self, selector: #selector(scrollViewContentOffsetChanged(notification:)), name: UIScrollView.scrollViewContentOffsetChanged, object: nil)
  }
  
  func unsubscribeScrollViewNotications() {
    NotificationCenter.default.removeObserver(self, name: UIScrollView.scrollViewContentOffsetChanged, object: nil)
  }
  
  @objc func scrollViewContentOffsetChanged(notification: Notification) {
    guard let delegate = (self as? ScrollViewContentOffsetNotificationsDelegateProtocol) else {
      return
    }
    
    guard let userInfo = notification.userInfo else {
      return
    }
    
    guard let contentOffset = userInfo[UIScrollView.scrollViewContentOffsetKey] as? CGPoint,
          let oldContentOffset = userInfo[UIScrollView.scrollViewContentOffsetOldValueKey] as? CGPoint,
          let initialContentOffset = userInfo[UIScrollView.scrollViewInitialContentOffsetKey] as? CGPoint
    else {
      return
    }
    
    delegate.scrollViewDidChangeContentOffset(contentOffset, oldContentOffset: oldContentOffset, initialContentOffset: initialContentOffset)
  }
}
