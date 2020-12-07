//
//  VerifyCodeModuleApi.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 20.06.2018.
//Copyright © 2018 com.kazai. All rights reserved.
//

//MARK: - VerifyCodeModuleRouter API
import Foundation

protocol VerifyCodeRouterApi: RouterProtocol {
  func routeToMainTabbar()
  func routeToPhonePickModule()
  func routeToLogin()
}

//MARK: - VerifyCodeModuleView API
protocol VerifyCodeViewControllerApi: ViewControllerProtocol {
  func setCodeValueEmpty()
  func presentDimOverlayViewHidden(_ hidden: Bool)
  
  func setBackButtonHidden(_ hidden: Bool)
  func setResendButtonEnabled(_ enabled: Bool)
  func setResendCounterTitleValue(_ value: String)
  
  func setEditing(_ editing: Bool)
  func setPhoneNumber(_ value: String)
  
  func setInformationTitles(_ attributedTitle: NSAttributedString, attributedSubtitle: NSAttributedString)
  func setNavigationBarTitle(_ text: String)
  
  func showVerificationFailedAlert()
}

//MARK: - VerifyCodeModulePresenter API
protocol VerifyCodePresenterApi: PresenterProtocol {
  func codeValueChanged(_ value: String)
  func handeResentCodeAction()
  func handleHideAction()
  func handleVerificationErrorAction()
  
  func presentCodeValuePlaceholder()
  
  func presentCodeVerificationDidSend()
  func presentCodeVerificationSuccess(_ success: Bool)
  func presentVerificationAttemtsLimitExceedError()
  func presentResendAvailable(_ available: Bool)
  func presentTimerValue(_ interval: TimeInterval)
}

//MARK: - VerifyCodeModuleInteractor API
protocol VerifyCodeInteractorApi: InteractorProtocol {
  var purpose: VerifyCode.Purpose { get }
  
  func setCodeValue(_ value: String)
  func initResendTimer()
  func resendCode()
  func resendCodeIfNeeded()
}
