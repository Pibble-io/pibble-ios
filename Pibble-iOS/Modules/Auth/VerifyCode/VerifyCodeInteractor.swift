//
//  VerifyCodeModuleInteractor.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 20.06.2018.
//Copyright © 2018 com.kazai. All rights reserved.
//

import Foundation 

// MARK: - VerifyCodeModuleInteractor Class
final class VerifyCodeInteractor: Interactor {
  let purpose: VerifyCode.Purpose
  
  fileprivate let maxCodeLength = 4
  fileprivate var loginService: AuthServiceProtocol
  
  fileprivate var resendTimer: Timer?
  fileprivate var resendTimeInterval: TimeInterval = 30.0
  fileprivate let resendAllowedTimeInterval: TimeInterval = 30.0
  fileprivate var attemtsCount = 0
  fileprivate var attemtsCountLimit = 5
  
  fileprivate var resendExpirationDate: Date {
    switch purpose {
    case .phoneVerification(_):
      return loginService.canResendSMSVerificationAfter
    case .initialEmailVerification(_):
      return loginService.canResendEmailVerificationAfter
    case .forcedEmailVerification(_, _):
      return loginService.canResendEmailVerificationAfter
    }
  }
  
//  fileprivate var resendExpirationDate: Date {
//    switch purpose {
//    case .password(let method):
//      switch method {
//      case .phoneNumber(_):
//        return loginService.canResendSMSVerificationAfter
//      case .email(_):
//        return loginService.canResendEmailVerificationAfter
//      }
//    case .pinCode(let method):
//      switch method {
//      case .phoneNumber(_):
//        return loginService.canResendSMSPinCodeResetAfter
//      case .email(_):
//        return loginService.canResendEmailPinCodeResetAfter
//      }
//    }
//  }
  
  fileprivate var resendExpirationTimeInterval: TimeInterval {
    return max(0.0, resendExpirationDate.timeIntervalSinceNow)
  }
  
  fileprivate var canResend: Bool {
    return resendExpirationDate.hasPassed
  }
  
  init(loginService: AuthServiceProtocol, purpose: VerifyCode.Purpose) {
    self.purpose = purpose
    self.loginService = loginService
  }
}

// MARK: - VerifyCodeModuleInteractor API
extension VerifyCodeInteractor: VerifyCodeInteractorApi {
  func initResendTimer() {
    presenter.presentResendAvailable(canResend)
    presenter.presentTimerValue(resendExpirationTimeInterval)
    
    resendTimer?.invalidate()
    resendTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { [weak self] _ in
      guard let strongSelf = self else {
        return
      }
      
      guard !strongSelf.canResend else {
        strongSelf.presenter.presentResendAvailable(strongSelf.canResend)
        strongSelf.resendTimer?.invalidate()
        return
      }
      
      strongSelf.presenter.presentTimerValue(strongSelf.resendExpirationTimeInterval)
    })
  }
  
  func resendCodeIfNeeded() {
    switch purpose {
    case .phoneVerification:
      break
    case .initialEmailVerification:
      resendCode()
    case .forcedEmailVerification:
      resendCode()
    }
  }
  
  func resendCode() {
    initResendTimer()
    guard canResend else {
      return
    }

    switch purpose {
    case .phoneVerification(let phoneNumber):
      loginService.sendVerificationSMSTo(phoneNumber) { [weak self] (err) in
        self?.initResendTimer()
        
        if let err = err {
          self?.presenter.handleError(err)
        }
      }
    case .initialEmailVerification(let emailAddress), .forcedEmailVerification(let emailAddress, _):
      loginService.sendVerificationEmailTo(emailAddress) { [weak self] (err) in
        self?.initResendTimer()
        
        if let err = err {
          self?.presenter.handleError(err)
        }
      }
    }   
  }
  
  fileprivate func checkMaxAttemptsCount() {
    attemtsCount += 1
    guard attemtsCount < attemtsCountLimit else {
      loginService.logout()
      presenter.presentVerificationAttemtsLimitExceedError()
      return
    }
  }
  
  func setCodeValue(_ value: String) {
    if value.count >= maxCodeLength {
      let indexEndOfText = value.index(value.startIndex, offsetBy: maxCodeLength)
      let cutCodeValue = String(value[..<indexEndOfText])
      
      presenter.presentCodeVerificationDidSend()
      
      let completionHandler: CompleteHandler = { [weak self] in
        guard let strongSelf = self else {
          return
        }
        strongSelf.presenter.presentCodeValuePlaceholder()
        strongSelf.presenter.presentCodeVerificationSuccess($0 == nil)
        
        if let error = $0 {
          strongSelf.checkMaxAttemptsCount()
          strongSelf.presenter.handleError(error)
        }
      }
      
      switch purpose {
      case .phoneVerification(_):
        loginService.checkCodeForPhoneNumber(code: cutCodeValue) { [weak self] in
          guard let strongSelf = self else {
            return
          }
          
          strongSelf.presenter.presentCodeValuePlaceholder()
          strongSelf.presenter.presentCodeVerificationSuccess($0 == nil)
          
          
          guard let error = $0 else {
            strongSelf.loginService.confirmAccountCreation(completionHandler)
            return
          }
          
          strongSelf.checkMaxAttemptsCount()
          strongSelf.presenter.handleError(error)
        }
      case .initialEmailVerification(_):
        loginService.checkCodeForEmail(code: cutCodeValue, complete: completionHandler)
      case .forcedEmailVerification(_):
        loginService.checkCodeForEmail(code: cutCodeValue, complete: completionHandler)
      }
    }
  }
}

// MARK: - Interactor Viper Components Api
private extension VerifyCodeInteractor {
    var presenter: VerifyCodePresenterApi {
        return _presenter as! VerifyCodePresenterApi
    }
}

