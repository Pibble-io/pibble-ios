//
//  WalletPincodeSecuredPresenter.swift
//  Pibble
//
//  Created by Kazakov Sergey on 27.09.2018.
//  Copyright © 2018 com.kazai. All rights reserved.
//

import Foundation


class WalletPinCodeUnlockProxyDelegate: WalletPinCodeUnlockDelegateProtocol {
  fileprivate let unlockBlock: (Bool) -> Void
  
  init(unlockBlock: @escaping (Bool) -> Void) {
    self.unlockBlock = unlockBlock
  }
  
  func walletDidUnlockWith(_ pinCode: String) {
    unlockBlock(true)
  }
  
  func walletDidFailToUnlock() {
    unlockBlock(false)
  }
}

class WalletPinCodeSecuredPresenter: Presenter {
  fileprivate static var isWalletLocked = true
  fileprivate static var walletUnlockDate = Date(timeIntervalSince1970: 0.0)

  fileprivate let walletUnlockOnDidBecomeActiveTimeOut: TimeInterval = 15.0
  fileprivate let walletUnlockOnAppearanceTimeOut: TimeInterval = 10.0
 
  fileprivate var isCurrentWalletScreenLocked = true
  
  var shouldLockOnFirstAppearance: Bool {
    return false
  }
  
  fileprivate var isWalletLockedOnDidBecomeActive: Bool {
    return abs(WalletPinCodeSecuredPresenter.walletUnlockDate.timeIntervalSinceNow) > walletUnlockOnDidBecomeActiveTimeOut
  }
  
  fileprivate var isWalletLockedOnAppearance: Bool {
    guard shouldLockOnFirstAppearance else {
      return false
    }
    
    guard isCurrentWalletScreenLocked else {
      return false
    }
    
    return abs(WalletPinCodeSecuredPresenter.walletUnlockDate.timeIntervalSinceNow) > walletUnlockOnAppearanceTimeOut
  }
  
  fileprivate lazy var walletPinCodeUnlockDelegate = {
    return WalletPinCodeUnlockProxyDelegate(unlockBlock: unlockHandler)
  }()
  
  fileprivate func unlockHandler(_ success: Bool) {
    guard success else {
      self._router.routeToRoot(animated: true)
      return
    }
    isCurrentWalletScreenLocked = false
    WalletPinCodeSecuredPresenter.isWalletLocked = false
    WalletPinCodeSecuredPresenter.walletUnlockDate = Date()
  }
  
  override func viewWillAppear() {
    super.viewWillAppear()
    guard let securedRouter = self._router as? WalletPinCodeSecuredRouterProtocol else {
      return
    }
    
    guard isWalletLockedOnAppearance else {
      return
    }
    
    WalletPinCodeSecuredPresenter.isWalletLocked = true
    securedRouter.routeToPinCodeUnlockWith(delegate: walletPinCodeUnlockDelegate)
  }
  
  
  override func willBecomeActive() {
    super.willBecomeActive()
    guard let securedRouter = self._router as? WalletPinCodeSecuredRouterProtocol else {
      return
    }
    
    guard isWalletLockedOnDidBecomeActive else {
      return
    }
    
    WalletPinCodeSecuredPresenter.isWalletLocked = true
    securedRouter.routeToPinCodeUnlockWith(delegate: walletPinCodeUnlockDelegate)
  }
  
  override func viewWillDisappear() {
    super.viewWillDisappear()
    guard !WalletPinCodeSecuredPresenter.isWalletLocked else {
      return
    }
    
    WalletPinCodeSecuredPresenter.walletUnlockDate = Date()
  }
  
  override func willResignActive() {
    super.willResignActive()
    guard !WalletPinCodeSecuredPresenter.isWalletLocked else {
      return
    }
    
    WalletPinCodeSecuredPresenter.walletUnlockDate = Date()
  }
}
