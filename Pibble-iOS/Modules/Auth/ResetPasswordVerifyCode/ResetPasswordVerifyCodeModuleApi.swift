//
//  ResetPasswordVerifyCodeModuleApi.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 26.06.2018.
//Copyright © 2018 com.kazai. All rights reserved.
//

import Foundation

//MARK: - ResetPasswordVerifyCodeModuleRouter API
protocol ResetPasswordVerifyCodeRouterApi: RouterProtocol {
  func routeToChangePasswordWith(confirmationToken: String)
  func routeToChangePinCodeWith(confirmationToken: String, delegate: WalletPinCodeUnlockDelegateProtocol)
  func routeToLogin() 
}

//MARK: - ResetPasswordVerifyCodeModuleView API
protocol ResetPasswordVerifyCodeViewControllerApi: ViewControllerProtocol {
  func setCodeValueEmpty()
  func presentDimOverlayViewHidden(_ hidden: Bool)
  
  func setResendButtonEnabled(_ enabled: Bool)
  func setResendCounterTitleValue(_ value: String)
  
  func setEditing(_ editing: Bool)
  func setTargetAddress(_ value: String)
  func setNavBarTitle(_ value: String)
  
  func showVerificationFailedAlert()
}

//MARK: - ResetPasswordVerifyCodeModulePresenter API
protocol ResetPasswordVerifyCodePresenterApi: PresenterProtocol {
  func codeValueChanged(_ value: String)
  func handeResentCodeAction()
  func handleHideAction()
  func handleVerificationErrorAction()
  
  func presentCodeValuePlaceholder()
  
  func presentCodeVerificationDidSend()
  func presentCodeVerificationSuccess(_ success: Bool, confirmationToken: String)
  func presentVerificationAttemtsLimitExceedError()
  func presentResendAvailable(_ available: Bool)
  func presentTimerValue(_ interval: TimeInterval)
}

//MARK: - ResetPasswordVerifyCodeModuleInteractor API
protocol ResetPasswordVerifyCodeInteractorApi: InteractorProtocol {
  var purpose: ResetPasswordVerifyCode.Purpose { get }
  
  func setCodeValue(_ value: String)
  func initResendTimer()
  func resendCode()
}


