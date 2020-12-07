//
//  VerifyCodeModulePresenter.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 20.06.2018.
//Copyright © 2018 com.kazai. All rights reserved.
//

import UIKit

// MARK: - VerifyCodeModulePresenter Class
final class VerifyCodePresenter: Presenter {
  override func viewWillAppear() {
    super.viewWillAppear()
    viewController.presentDimOverlayViewHidden(true)
    
    let titles = attributedTitleForPurpose(interactor.purpose)
    viewController.setInformationTitles(titles.title, attributedSubtitle: titles.subtitle)
    let navBarTitle = VerifyCode.Strings.navigationBarTitleForPurpose(interactor.purpose)
    viewController.setNavigationBarTitle(navBarTitle)
    
    switch interactor.purpose {
    case .phoneVerification(_):
      viewController.setBackButtonHidden(false)
    case .initialEmailVerification(_):
      viewController.setBackButtonHidden(true)
    case .forcedEmailVerification(_):
      viewController.setBackButtonHidden(true)
    }
    
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

// MARK: - VerifyCodeModulePresenter API
extension VerifyCodePresenter: VerifyCodePresenterApi {
  func handleVerificationErrorAction() {
    router.routeToLogin()
  }
  
  func presentVerificationAttemtsLimitExceedError() {
     viewController.showVerificationFailedAlert()
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
  
  func presentCodeVerificationSuccess(_ success: Bool) {
    viewController.presentDimOverlayViewHidden(true)
    guard success else {
      viewController.setEditing(true)
      return
    }
    
    switch interactor.purpose {
    case .phoneVerification:
      router.routeToMainTabbar()
    case .initialEmailVerification(_):
      router.routeToPhonePickModule()
    case .forcedEmailVerification(_, let phoneVerificationNeeded):
      guard phoneVerificationNeeded else {
        router.routeToMainTabbar()
        return
      }
      
      router.routeToPhonePickModule()
    }
  }
  
  func codeValueChanged(_ value: String) {
    interactor.setCodeValue(value)
  }
  
  func presentCodeValuePlaceholder() {
    viewController.setCodeValueEmpty()
  }
}

// MARK: - VerifyCodeModule Viper Components
fileprivate extension VerifyCodePresenter {
    var viewController: VerifyCodeViewControllerApi {
        return _viewController as! VerifyCodeViewControllerApi
    }
    var interactor: VerifyCodeInteractorApi {
        return _interactor as! VerifyCodeInteractorApi
    }
    var router: VerifyCodeRouterApi {
        return _router as! VerifyCodeRouterApi
    }
}

// MARK: - Helpers
extension VerifyCodePresenter {
  func attributedTitleForPurpose(_ purpose:  VerifyCode.Purpose) -> (title: NSAttributedString, subtitle: NSAttributedString)  {
    let attributedTitle: NSAttributedString
    let attributedSubtitle: NSAttributedString
    
    switch purpose {
    case .phoneVerification:
      attributedTitle =
        NSAttributedString(string: VerifyCode.Strings.informationTitleForPurpose(purpose),
                           attributes: [
                            NSAttributedString.Key.font: UIConstants.Fonts.phoneTitle,
                            NSAttributedString.Key.foregroundColor: UIConstants.Colors.titleColor])
      attributedSubtitle =
        NSAttributedString(string: VerifyCode.Strings.informationSubtitleForPurpose(purpose),
                           attributes: [
                            NSAttributedString.Key.font: UIConstants.Fonts.phoneSubtitle,
                            NSAttributedString.Key.foregroundColor: UIConstants.Colors.titleColor])
    case .initialEmailVerification, .forcedEmailVerification:
      attributedTitle =
        NSAttributedString(string: VerifyCode.Strings.informationTitleForPurpose(purpose),
                           attributes: [
                            NSAttributedString.Key.font: UIConstants.Fonts.emailTitle,
                            NSAttributedString.Key.foregroundColor: UIConstants.Colors.titleColor])
      attributedSubtitle =
        NSAttributedString(string: VerifyCode.Strings.informationSubtitleForPurpose(purpose),
                           attributes: [
                            NSAttributedString.Key.font: UIConstants.Fonts.emailSubtitle,
                            NSAttributedString.Key.foregroundColor: UIConstants.Colors.titleColor])
    }
    
    return (title: attributedTitle, subtitle: attributedSubtitle)
  }
}

fileprivate enum UIConstants {
  enum Colors {
    static let titleColor = UIColor.white
  }
  enum Fonts {
    static let emailTitle = UIFont.AvenirNextDemiBold(size: 26.0)
    static let emailSubtitle = UIFont.AvenirNextMedium(size: 14.0)
    
    static let phoneTitle = UIFont.AvenirNextMedium(size: 14.0)
    static let phoneSubtitle = UIFont.AvenirNextDemiBold(size: 14.0)
  }
}

extension VerifyCode {
  enum Strings {
    enum NavigationBarTitleForPurpose: String, LocalizedStringKeyProtocol {
      case enterVerifyCode = "Enter Verify Code"
      case verifyEmail = "Verify Email"
    }
    
    enum InformationTitleForPurpose: String, LocalizedStringKeyProtocol{
      case phoneVerification = "Please check your SMS. We just sent a verification code to: "
    }
    
    enum InformationSubtitleForPurpose: String, LocalizedStringKeyProtocol {
      case initialEmailVerification = "Please enter the verification code we e-mailed"
      case forcedEmailVerification =  "Your e-mail is not verified yet. Please enter the verification code we e-mailed"
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
    
    static func navigationBarTitleForPurpose(_ purpose:  VerifyCode.Purpose) -> String {
      switch purpose {
      case .phoneVerification:
        return NavigationBarTitleForPurpose.enterVerifyCode.localize()
      case .initialEmailVerification, .forcedEmailVerification:
        return NavigationBarTitleForPurpose.verifyEmail.localize()
      }
    }
    
    static func informationTitleForPurpose(_ purpose:  VerifyCode.Purpose) -> String {
      switch purpose {
      case .phoneVerification:
        return InformationTitleForPurpose.phoneVerification.localize()
      case .initialEmailVerification(let email), .forcedEmailVerification(let email, _):
        return email
      }
    }
    
    static func informationSubtitleForPurpose(_ purpose:  VerifyCode.Purpose) -> String {
      switch purpose {
      case .phoneVerification(let phoneNumber):
        return phoneNumber.phone
      case .initialEmailVerification:
        return InformationSubtitleForPurpose.initialEmailVerification.localize()
      case .forcedEmailVerification:
        return InformationSubtitleForPurpose.forcedEmailVerification.localize()
      }
    }
  }
}
