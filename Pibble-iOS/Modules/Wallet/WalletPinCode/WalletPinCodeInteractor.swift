//
//  WalletPinCodeInteractor.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 12.09.2018.
//Copyright © 2018 com.kazai. All rights reserved.
//

import Foundation 

// MARK: - WalletPinCodeInteractor Class
final class WalletPinCodeInteractor: Interactor {
  fileprivate var pickedDigits: [Int] = []
  fileprivate let pickedDigitsCountMax = 4
  
  var pinCodePurpose: WalletPinCode.PinCodePurpose {
    didSet {
      pickedDigits = []
      presenter.presentPickedDigits(pickedDigits)
      presenter.presentPurpose(pinCodePurpose)
    }
  }
  
  fileprivate let walletService: WalletServiceProtocol
  fileprivate let accountProfileService: AccountProfileServiceProtocol
  fileprivate let authService: AuthServiceProtocol
  
  init(walletService: WalletServiceProtocol,
       accountProfileService: AccountProfileServiceProtocol,
       authService: AuthServiceProtocol,
       pinCodePurpose: WalletPinCode.PinCodePurpose) {
    self.walletService = walletService
    self.pinCodePurpose = pinCodePurpose
    self.accountProfileService = accountProfileService
    self.authService = authService
  }
}

// MARK: - WalletPinCodeInteractor API
extension WalletPinCodeInteractor: WalletPinCodeInteractorApi {
  func fetchInitialData() {
    switch pinCodePurpose {
    case .registerNewPinCode:
      return
    case .confirmNewPinCode:
      return
    case .unlock:
      if let userProfile = accountProfileService.currentUserAccount,
        !userProfile.hasPinCode {
          pinCodePurpose = .registerNewPinCode
          return
      }
      
      accountProfileService.getProfile { [weak self] in
        switch $0 {
        case .success(let profile):
          guard profile.hasPinCode else {
            self?.pinCodePurpose = .registerNewPinCode
            return
          }
        case .failure(let err):
          self?.presenter.handleError(err)
        }
      }
    case .restorePinCode:
      return
    case .confirmRestorePinCode:
      return
    }
  }
  
  func appendPinCodeDigitValue(_ value: Int) {
    guard pickedDigits.count < pickedDigitsCountMax else {
      return
    }
    pickedDigits.append(value)
    presenter.presentPickedDigits(pickedDigits)
    checkPinCode()
  }
  
  func removeLastPinCodeDigitValue() {
    guard pickedDigits.count > 0 else {
      return
    }
    
    pickedDigits.removeLast()
    presenter.presentPickedDigits(pickedDigits)
  }
}

// MARK: - Interactor Viper Components Api
private extension WalletPinCodeInteractor {
  var presenter: WalletPinCodePresenterApi {
    return _presenter as! WalletPinCodePresenterApi
  }
}

extension WalletPinCodeInteractor {
  func performEmailResetCodeRequest() {
    accountProfileService.getProfile { [weak self] in
      guard let strongSelf = self else {
        return
      }
      
      switch $0 {
      case .success(let accountProfile):
        let email = ResetPasswordEmail(email: accountProfile.accountProfileEmail)
        
        strongSelf.presenter.presentSendingRequestFinished()
        strongSelf.presenter.presentEmailResetCodeSentSuccessTo(email)
        
//        strongSelf.authService.sendResetPinCodeTo(email, complete: { [weak self] in
//          guard let strongSelf = self else {
//            return
//          }
//          strongSelf.presenter.presentSendingRequestFinished()
//
//          if let error = $0 {
//            strongSelf.presenter.handleError(error)
//            return
//          }
//
//          strongSelf.presenter.presentEmailResetCodeSentSuccessTo(email)
//        })
      case .failure(let error):
        strongSelf.presenter.handleError(error)
      }
    }
  }
  
  fileprivate func checkPinCode() {
    guard pickedDigits.count == pickedDigitsCountMax else {
      return
    }
    
    switch pinCodePurpose {
    case .registerNewPinCode:
      let pinCode = pickedDigits
        .map { String($0) }
        .joined()
      pickedDigits = []
      presenter.presentPinCodeCheckSuccess(pinCode)
    case .confirmNewPinCode(let prevPickedPinCode):
      let pinCode = pickedDigits
        .map { String($0) }
        .joined()
     
      guard pinCode == prevPickedPinCode else {
        presenter.presentPinCodeCheckFailure()
        pickedDigits = []
        return
      }
      presenter.presentPinCodeCheckingInProgress()
      walletService.registerPinCode(pinCode: pinCode) { [weak self] in
        guard let strongSelf = self else {
          return
        }
        
        strongSelf.pickedDigits = []
        if let err = $0 {
          strongSelf.presenter.presentPinCodeCheckFailure()
          strongSelf.presenter.handleError(err)
          return
        }
        
        strongSelf.presenter.presentPinCodeCheckSuccess(pinCode)
      }
    case .unlock:
      let pinCode = pickedDigits
        .map { String($0) }
        .joined()
      presenter.presentPinCodeCheckingInProgress()
      walletService.checkPinCode(pinCode: pinCode) { [weak self] in
        guard let strongSelf = self else {
          return
        }
        
        strongSelf.pickedDigits = []
        switch $0 {
        case .success(let res):
          guard res else {
            strongSelf.presenter.presentPinCodeCheckFailure()
            return
          }
          strongSelf.presenter.presentPinCodeCheckSuccess(pinCode)
        case .failure(let err):
          strongSelf.presenter.presentPinCodeCheckFailure()
          strongSelf.presenter.handleError(err)
        }
      }
    case .restorePinCode:
      let pinCode = pickedDigits
        .map { String($0) }
        .joined()
      pickedDigits = []
      presenter.presentPinCodeCheckSuccess(pinCode)
    case .confirmRestorePinCode(let token, let prevPickedPinCode):
      let pinCode = pickedDigits
        .map { String($0) }
        .joined()
      
      guard pinCode == prevPickedPinCode else {
        presenter.presentPinCodeCheckFailure()
        pickedDigits = []
        return
      }
      presenter.presentPinCodeCheckingInProgress()
      walletService.changePinCode(pinCode, token: token) { [weak self] in
        guard let strongSelf = self else {
          return
        }
        
        strongSelf.pickedDigits = []
        if let err = $0 {
          strongSelf.presenter.presentPinCodeCheckFailure()
          strongSelf.presenter.handleError(err)
          return
        }
        
        strongSelf.presenter.presentPinCodeCheckSuccess(pinCode)
      }
    }
  }
}
