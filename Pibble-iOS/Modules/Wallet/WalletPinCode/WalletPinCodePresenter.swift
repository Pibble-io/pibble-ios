//
//  WalletPinCodePresenter.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 12.09.2018.
//Copyright © 2018 com.kazai. All rights reserved.
//

import Foundation

// MARK: - WalletPinCodePresenter Class
final class WalletPinCodePresenter: Presenter {
  fileprivate let digits: [[WalletPinCode.Digit]]
  
  fileprivate var pinCodePurpose: WalletPinCode.PinCodePurpose {
    return interactor.pinCodePurpose
  }
  
  fileprivate weak var pinCodeUnlockDelegate: WalletPinCodeUnlockDelegateProtocol?
  
  init(pinCodeUnlockDelegate: WalletPinCodeUnlockDelegateProtocol) {
    
    self.pinCodeUnlockDelegate = pinCodeUnlockDelegate
    
    var inputDigits: [WalletPinCode.Digit] = Array(1...9).map { return .digit($0) }
    inputDigits.append(.digitWithControls(0))
    
    digits = [inputDigits]
    super.init()
  }
  
  override func viewWillAppear() {
    super.viewWillAppear()
    switch pinCodePurpose {
    case .registerNewPinCode:
      viewController.setRestorePincodeButtonHidden(true)
    case .confirmNewPinCode:
      viewController.setRestorePincodeButtonHidden(true)
    case .unlock:
      viewController.setRestorePincodeButtonHidden(false)
    case .restorePinCode:
      viewController.setRestorePincodeButtonHidden(true)
    case .confirmRestorePinCode:
      viewController.setRestorePincodeButtonHidden(true)
    }
    
    viewController.setPickedDigits([])
    viewController.showLoaderViewHidden(true)
    viewController.setPurposeTitle(pinCodePurpose.title)
    interactor.fetchInitialData()
  }
}

// MARK: - WalletPinCodePresenter API
extension WalletPinCodePresenter: WalletPinCodePresenterApi {
  func presentSendingRequestFinished() {
    viewController.showLoaderViewHidden(true)
  }
  
  func presentEmailResetCodeSentSuccessTo(_ email: ResetPasswordEmailProtocol) {
    router.routeToCodeVerificationWith(email)
  }
  
  func handleResetPinCodeAction() {
    viewController.showLoaderViewHidden(false)
    interactor.performEmailResetCodeRequest()
  }
  
  func presentPinCodeCheckingInProgress() {
    viewController.showLoaderViewHidden(false)
  }
  
  func presentPurpose(_ purpose: WalletPinCode.PinCodePurpose) {
    viewController.setPurposeTitle(purpose.title)
    switch pinCodePurpose {
    case .registerNewPinCode:
      viewController.setRestorePincodeButtonHidden(true)
    case .confirmNewPinCode:
      viewController.setRestorePincodeButtonHidden(true)
    case .unlock:
      viewController.setRestorePincodeButtonHidden(false)
    case .restorePinCode:
      viewController.setRestorePincodeButtonHidden(true)
    case .confirmRestorePinCode:
      viewController.setRestorePincodeButtonHidden(true)
    }
  }
  
  func presentPinCodeCheckSuccess(_ pinCode: String) {
    viewController.showLoaderViewHidden(true)
    switch pinCodePurpose {
    case .registerNewPinCode:
      interactor.pinCodePurpose = .confirmNewPinCode(pinCode)
    case .confirmNewPinCode(_):
      pinCodeUnlockDelegate?.walletDidUnlockWith(pinCode)
      router.dismiss(removeFromParentIfPossible: true)
    case .unlock:
      pinCodeUnlockDelegate?.walletDidUnlockWith(pinCode)
      router.dismiss(removeFromParentIfPossible: true)
    case .restorePinCode(let token):
      interactor.pinCodePurpose = .confirmRestorePinCode(token: token, pinCode: pinCode)
    case .confirmRestorePinCode:
      pinCodeUnlockDelegate?.walletDidUnlockWith(pinCode)
      router.dismiss(removeFromParentIfPossible: true)
    }
  }
  
  func presentPinCodeCheckFailure() {
    viewController.showLoaderViewHidden(true)
    viewController.showFailAnimaion()
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [weak self] in
      self?.viewController.setPickedDigits([])
    }
  }
  
  func presentPickedDigits(_ digits: [Int]) {
    let picked = digits.map { _ in return true }
    viewController.setPickedDigits(picked)
  }
  
  func handleLeftControlAction() {
    switch pinCodePurpose {
    case .registerNewPinCode:
      pinCodeUnlockDelegate?.walletDidFailToUnlock()
      router.dismiss()
    case .confirmNewPinCode(_):
      interactor.pinCodePurpose = .registerNewPinCode
    case .unlock:
      pinCodeUnlockDelegate?.walletDidFailToUnlock()
      router.dismiss()
    case .restorePinCode:
      pinCodeUnlockDelegate?.walletDidFailToUnlock()
      router.dismiss()
    case .confirmRestorePinCode(let token, _):
      interactor.pinCodePurpose = .restorePinCode(token: token)
    }
  }
  
  func handleRightControlAction() {
    interactor.removeLastPinCodeDigitValue()
  }
  
  func numberOfSections() -> Int {
    return digits.count
  }
  
  func numberOfItemsInSection(_ section: Int) -> Int {
    return digits[section].count
  }
  
  func itemViewModelFor(_ indexPath: IndexPath) -> WalletPinCode.DigitItemType {
    let digitItem = digits[indexPath.section][indexPath.item]
    switch digitItem {
    case .digit:
      return .digit(digitItem)
    case .digitWithControls:
      return .digitWithControls(digitItem)
    }
  }
  
  func handlePickItemAt(_ indexPath: IndexPath) {
    let digitItem = digits[indexPath.section][indexPath.item]
    interactor.appendPinCodeDigitValue(digitItem.value)
  }
}

// MARK: - WalletPinCode Viper Components
fileprivate extension WalletPinCodePresenter {
  var viewController: WalletPinCodeViewControllerApi {
    return _viewController as! WalletPinCodeViewControllerApi
  }
  var interactor: WalletPinCodeInteractorApi {
    return _interactor as! WalletPinCodeInteractorApi
  }
  var router: WalletPinCodeRouterApi {
    return _router as! WalletPinCodeRouterApi
  }
}

extension WalletPinCode.Digit: DigitViewModelProtocol {
  var title: String {
    switch self {
    case .digit(let number):
      return String(number)
    case .digitWithControls(let number):
      return String(number)
    }
  }
}


extension WalletPinCode.Digit: DigitWithControlsViewModelProtocol {
  var leftTitle: String {
    return WalletPinCode.Strings.leftDigitButton.localize()
  }
  
  var rightTitle: String {
    return WalletPinCode.Strings.rightDigitButton.localize()
  }
}

extension WalletPinCode.PinCodePurpose {
  fileprivate var title: String {
    switch self {
    case .registerNewPinCode:
      return WalletPinCode.Strings.registerNewPinCode.localize()
    case .confirmNewPinCode:
       return WalletPinCode.Strings.confirmNewPinCode.localize()
    case .unlock:
       return WalletPinCode.Strings.unlock.localize()
    case .restorePinCode:
      return WalletPinCode.Strings.restorePinCode.localize()
    case .confirmRestorePinCode:
      return WalletPinCode.Strings.confirmNewPinCode.localize()
    }
  }
}

extension WalletPinCode {
  enum Strings: String, LocalizedStringKeyProtocol {
    case registerNewPinCode = "Register PIN to access wallet"
    case confirmNewPinCode = "Confirm new PIN"
    case unlock = "Unlock with your PIN"
    case restorePinCode = "Register new PIN to access wallet"
    
    case leftDigitButton = "Cancel"
    case rightDigitButton = "BACK"
  }
}



