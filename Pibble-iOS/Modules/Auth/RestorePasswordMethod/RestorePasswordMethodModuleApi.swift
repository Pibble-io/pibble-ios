//
//  RestorePasswordMethodModuleApi.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 22.06.2018.
//Copyright © 2018 com.kazai. All rights reserved.
//

//MARK: - RestorePasswordMethodModuleRouter API
protocol RestorePasswordMethodRouterApi: RouterProtocol {
  func routeToEmailRestoreModule()
  func routeToSMSRestoreModule()
  
  func routeToCodeVerificationWith(_ phone: UserPhoneNumberProtocol)
  func routeToCodeVerificationWith(_ email: ResetPasswordEmailProtocol)
}

//MARK: - RestorePasswordMethodModuleView API
protocol RestorePasswordMethodViewControllerApi: ViewControllerProtocol {
  func setNavigationBarTitle(_ text: String)
  func setInformationTitle(_ text: String)
  func setDimViewHidden(_ hidden: Bool)
}

//MARK: - RestorePasswordMethodModulePresenter API
protocol RestorePasswordMethodPresenterApi: PresenterProtocol {
  func handleSMSRestoreMethodAction()
  func handleEmailRestoreMethodAction()
  func handleHideAction()
  
  func presentSMSResetCodeSentSuccessTo(_ phone: UserPhoneNumberProtocol)
  func presentEmailResetCodeSentSuccessTo(_ email: ResetPasswordEmailProtocol)
  
  func presentSendingRequestFinished()
}

//MARK: - RestorePasswordMethodModuleInteractor API
protocol RestorePasswordMethodInteractorApi: InteractorProtocol {
  var purpose: RestorePasswordMethod.Purpose { get }
  func performSMSResetCodeRequest()
  func performEmailResetCodeRequest()
}
