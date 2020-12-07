//
//  ResetPasswordVerifyCodeModuleInteractor.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 26.06.2018.
//Copyright © 2018 com.kazai. All rights reserved.
//

import Foundation 

// MARK: - ResetPasswordVerifyCodeModuleInteractor Class
final class ResetPasswordVerifyCodeInteractor: Interactor {
  //var phoneNumber: UserPhoneNumberProtocol
  let purpose: ResetPasswordVerifyCode.Purpose
  
  fileprivate let maxCodeLength = 4
  fileprivate var loginService: AuthServiceProtocol
  
  fileprivate var resendTimer: Timer?
  
  fileprivate var resendExpirationDate: Date {
    switch purpose {
    case .password(let method):
      switch method {
      case .phoneNumber(_):
        return loginService.canResendSMSVerificationAfter
      case .email(_):
        return loginService.canResendEmailVerificationAfter
      }
    case .pinCode(let method):
      switch method {
      case .phoneNumber(_):
        return loginService.canResendSMSPinCodeResetAfter
      case .email(_):
        return loginService.canResendEmailPinCodeResetAfter
      }
    }
  }
  
  fileprivate var resendExpirationTimeInterval: TimeInterval {
    return max(0.0, resendExpirationDate.timeIntervalSinceNow)
  }
  
  fileprivate var canResend: Bool {
    return resendExpirationDate.hasPassed
  }
  
  fileprivate var attemtsCount = 0
  fileprivate var attemtsCountLimit = 5
  
  init(loginService: AuthServiceProtocol, purpose: ResetPasswordVerifyCode.Purpose) {
    self.loginService = loginService
    self.purpose = purpose
  }
}

// MARK: - ResetPasswordVerifyCodeModuleInteractor API
extension ResetPasswordVerifyCodeInteractor: ResetPasswordVerifyCodeInteractorApi {
  /*
   func initResendTimerOld() {
    resendTimeInterval = resendAllowedTimeInterval
    
    presenter.presentResendAvailable(false)
    presenter.presentTimerValue(resendTimeInterval)
    
    resendTimer?.invalidate()
    resendTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { [weak self] _ in
      guard let strongSelf = self else {
        return
      }
      
      guard strongSelf.resendTimeInterval > 0.001 else {
        strongSelf.presenter.presentResendAvailable(true)
        strongSelf.resendTimer?.invalidate()
        return
      }
      
      strongSelf.resendTimeInterval -= 1.0
      strongSelf.presenter.presentTimerValue(strongSelf.resendTimeInterval)
    })
  }*/
  
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
  
  fileprivate func checkMaxAttemptsCount() {
    attemtsCount += 1
    guard attemtsCount < attemtsCountLimit else {
      switch purpose {
      case .password(_):
        loginService.logout()
      case .pinCode(_):
        loginService.applyTempBanForPinCodeReset()
      }
      
      presenter.presentVerificationAttemtsLimitExceedError()
      return
    }
  }
  
  func resendCode() {
    initResendTimer()
    guard canResend else {
      return
    }
    
    switch purpose {
    case .password(let method):
      switch method {
      case .phoneNumber(let phoneNumber):
        loginService.sendResetPasswordTo(phoneNumber) { [weak self] (err) in
          self?.initResendTimer()
          
          if let err = err {
            self?.presenter.handleError(err)
          }
        }
      case .email(let emailAddress):
        loginService.sendResetPasswordTo(emailAddress) { [weak self] (err) in
          self?.initResendTimer()
          
          if let err = err {
            self?.presenter.handleError(err)
          }
        }
      }
    case .pinCode(let method):
      switch method {
      case .phoneNumber(let phoneNumber):
        loginService.sendResetPinCodeTo(phoneNumber) { [weak self] (err) in
          self?.initResendTimer()
          
          if let err = err {
            self?.presenter.handleError(err)
          }
        }
      case .email(let emailAddress):
        loginService.sendResetPinCodeTo(emailAddress) { [weak self] (err) in
          self?.initResendTimer()
          
          if let err = err {
            self?.presenter.handleError(err)
          }
        }
      }
    }
  }
  
  func setCodeValue(_ value: String) {
    if value.count >= maxCodeLength {
      let indexEndOfText = value.index(value.startIndex, offsetBy: maxCodeLength)
      let cutCodeValue = String(value[..<indexEndOfText])
      
      presenter.presentCodeVerificationDidSend()
      
      let completeBlock: ResultCompleteHandler<VerifiedCodeProtocol, PibbleError> = { [weak self] in
        guard let strongSelf = self else {
          return
        }
        
        strongSelf.presenter.presentCodeValuePlaceholder()
        switch $0 {
        case .success(let verifiedCode):
          strongSelf.presenter.presentCodeVerificationSuccess(true, confirmationToken: verifiedCode.token)
        case .failure(let error):
          strongSelf.checkMaxAttemptsCount()
          strongSelf.presenter.presentCodeVerificationSuccess(false, confirmationToken: "")
          strongSelf.presenter.handleError(error)
        }
      }
      
      switch purpose {
      case .password(let method):
        switch method {
        case .phoneNumber(_):
          loginService.resetPasswordCheckSMSCode(code: cutCodeValue, complete: completeBlock)
        case .email(_):
          loginService.resetPasswordCheckEmailCode(code: cutCodeValue, complete: completeBlock)
        }
      case .pinCode(let method):
        switch method {
        case .phoneNumber(_):
          loginService.resetPasswordCheckSMSCode(code: cutCodeValue, complete: completeBlock)
        case .email(_):
          loginService.resetPasswordCheckEmailCode(code: cutCodeValue, complete: completeBlock)
        }
      }
    }
  }
}

// MARK: - Interactor Viper Components Api
private extension ResetPasswordVerifyCodeInteractor {
    var presenter: ResetPasswordVerifyCodePresenterApi {
        return _presenter as! ResetPasswordVerifyCodePresenterApi
    }
}
