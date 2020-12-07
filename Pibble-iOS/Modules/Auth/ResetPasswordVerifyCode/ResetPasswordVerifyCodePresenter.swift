//
//  ResetPasswordVerifyCodeModulePresenter.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 26.06.2018.
//Copyright © 2018 com.kazai. All rights reserved.
//

import Foundation

// MARK: - ResetPasswordVerifyCodeModulePresenter Class
final class ResetPasswordVerifyCodePresenter: Presenter {
  override func viewWillAppear() {
    super.viewWillAppear()
    switch interactor.purpose {
    case .password:
      viewController.setNavBarTitle(ResetPasswordVerifyCode.Strings.Password.navBarTitle.localize())
    case .pinCode:
      viewController.setNavBarTitle(ResetPasswordVerifyCode.Strings.PinCode.navBarTitle.localize())
    }
    
    viewController.presentDimOverlayViewHidden(true)
    viewController.setTargetAddress(sentTitleFor(interactor.purpose))
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    interactor.resendCode()
  }
  
  override func didBecomeActive() {
    super.didBecomeActive()
    viewController.setEditing(true)
  }
}

// MARK: - ResetPasswordVerifyCodeModulePresenter API
extension ResetPasswordVerifyCodePresenter: ResetPasswordVerifyCodePresenterApi {
  func handleVerificationErrorAction() {
    switch interactor.purpose {
    case .password(_):
      router.routeToLogin()
    case .pinCode(_):
      router.dismiss()
    }
  }
  
  func presentVerificationAttemtsLimitExceedError() {
    viewController.showVerificationFailedAlert()
  }
  
  func presentCodeValuePlaceholder() {
    viewController.setCodeValueEmpty()
  }
  
  func handleHideAction() {
    router.dismiss()
  }
  
  func handeResentCodeAction() {
    interactor.resendCode()
  }
  
  func presentResendAvailable(_ available: Bool) {
    viewController.setResendButtonEnabled(available)
  }
  
  func presentTimerValue(_ interval: TimeInterval) {
    viewController.setResendCounterTitleValue(String(Int(interval)))
  }
  
  func presentCodeVerificationDidSend() {
    viewController.presentDimOverlayViewHidden(false)
  }
  
  func presentCodeVerificationSuccess(_ success: Bool, confirmationToken: String) {
    viewController.presentDimOverlayViewHidden(true)
    guard success else {
      viewController.setEditing(true)
      return
    }
    
    switch interactor.purpose {
    case .password:
      router.routeToChangePasswordWith(confirmationToken: confirmationToken)
    case .pinCode(_):
      router.routeToChangePinCodeWith(confirmationToken: confirmationToken, delegate: self)
    }
  }
  
  func codeValueChanged(_ value: String) {
    interactor.setCodeValue(value)
  }
  
}

// MARK: - ResetPasswordVerifyCodeModule Viper Components
fileprivate extension ResetPasswordVerifyCodePresenter {
    var viewController: ResetPasswordVerifyCodeViewControllerApi {
        return _viewController as! ResetPasswordVerifyCodeViewControllerApi
    }
    var interactor: ResetPasswordVerifyCodeInteractorApi {
        return _interactor as! ResetPasswordVerifyCodeInteractorApi
    }
    var router: ResetPasswordVerifyCodeRouterApi {
        return _router as! ResetPasswordVerifyCodeRouterApi
    }
}

extension ResetPasswordVerifyCodePresenter: WalletPinCodeUnlockDelegateProtocol {
  func walletDidUnlockWith(_ pinCode: String) {
    router.routeToRoot(animated: true)
  }
  
  func walletDidFailToUnlock() {
    router.routeToRoot(animated: true)
  }
}

extension ResetPasswordVerifyCodePresenter {
  fileprivate func sentTitleFor(_ purpose: ResetPasswordVerifyCode.Purpose) -> String {
    switch purpose {
    case .password(let method):
      switch method {
      case .phoneNumber(let phoneNumber):
        return phoneNumber.phone
      case .email(let emailAddress):
        return emailAddress.email
      }
    case .pinCode(let method):
      switch method {
      case .phoneNumber(let phoneNumber):
        return phoneNumber.phone
      case .email(let emailAddress):
        return emailAddress.email
      }
    }
  }
}

extension ResetPasswordVerifyCode {
  enum Strings {
    enum Password: String, LocalizedStringKeyProtocol {
      case navBarTitle = "Forgot Password"
    }
    
    enum PinCode: String, LocalizedStringKeyProtocol {
      case navBarTitle = "Forgot PIN"
    }
    
    enum ResendButtonTitles: String, LocalizedStringKeyProtocol {
      case resend = "Resend code"
      case resendAfter = "Resend code after %s"
    }
    
    enum VerificationFailAlert: String, LocalizedStringKeyProtocol {
      case title = "Oh Snap!"
      case message = "Verification failed"
      case okAction = "Ok"
    }
    
    static func resendButtonTitleWith(_ counterString: String?) -> String {
      guard let counter = counterString else {
        return ResendButtonTitles.resend.localize()
      }
    
      return ResendButtonTitles.resendAfter.localize(value: counter)
    }
  
  }
}
