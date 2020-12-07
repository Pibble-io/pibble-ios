//
//  RestorePasswordMethodModulePresenter.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 22.06.2018.
//Copyright © 2018 com.kazai. All rights reserved.
//

import Foundation

// MARK: - RestorePasswordMethodModulePresenter Class
final class RestorePasswordMethodPresenter: Presenter {
  override func viewWillAppear() {
    super.viewWillAppear()
    viewController.setDimViewHidden(true)
    switch interactor.purpose {
    case .password:
      viewController.setNavigationBarTitle(RestorePasswordMethod.Strings.Password.navBarTitle.localize())
      viewController.setInformationTitle(RestorePasswordMethod.Strings.Password.information.localize())
    case .pinCode:
      viewController.setNavigationBarTitle(RestorePasswordMethod.Strings.PinCode.navBarTitle.localize())
      viewController.setInformationTitle(RestorePasswordMethod.Strings.PinCode.information.localize())
    }
  }
}

// MARK: - RestorePasswordMethodModulePresenter API
extension RestorePasswordMethodPresenter: RestorePasswordMethodPresenterApi {
  func presentSMSResetCodeSentSuccessTo(_ phone: UserPhoneNumberProtocol) {
    viewController.setDimViewHidden(true)
    router.routeToCodeVerificationWith(phone)
  }
  
  func presentEmailResetCodeSentSuccessTo(_ email: ResetPasswordEmailProtocol) {
    viewController.setDimViewHidden(true)
    router.routeToCodeVerificationWith(email)
  }
  
  func presentSendingRequestFinished() {
    viewController.setDimViewHidden(true)
  }
  
  func handleHideAction() {
    router.dismiss()
  }
  
  func handleSMSRestoreMethodAction() {
    switch interactor.purpose {
    case .password:
      router.routeToSMSRestoreModule()
    case .pinCode:
      viewController.setDimViewHidden(false)
      interactor.performSMSResetCodeRequest()
    }
  }
  
  func handleEmailRestoreMethodAction() {
    switch interactor.purpose {
    case .password:
      router.routeToEmailRestoreModule()
    case .pinCode:
      viewController.setDimViewHidden(false)
      interactor.performEmailResetCodeRequest()
    }
  }
}

// MARK: - RestorePasswordMethodModule Viper Components
fileprivate extension RestorePasswordMethodPresenter {
    var viewController: RestorePasswordMethodViewControllerApi {
        return _viewController as! RestorePasswordMethodViewControllerApi
    }
    var interactor: RestorePasswordMethodInteractorApi {
        return _interactor as! RestorePasswordMethodInteractorApi
    }
    var router: RestorePasswordMethodRouterApi {
        return _router as! RestorePasswordMethodRouterApi
    }
}

