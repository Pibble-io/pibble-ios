//
//  ResetPasswordEmailSentModulePresenter.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 25.06.2018.
//Copyright © 2018 com.kazai. All rights reserved.
//

import Foundation

// MARK: - ResetPasswordEmailSentModulePresenter Class
final class ResetPasswordEmailSentPresenter: Presenter {
 
  override func viewWillAppear() {
    super.viewWillAppear()
    viewController.setEmailSentText(interactor.email.email)
  }
}

// MARK: - ResetPasswordEmailSentModulePresenter API
extension ResetPasswordEmailSentPresenter: ResetPasswordEmailSentPresenterApi {
  func handleNextStepAction() {
    router.routeToVerifyCodeWith(interactor.email)
  }
  
}

// MARK: - ResetPasswordEmailSentModule Viper Components

fileprivate extension ResetPasswordEmailSentPresenter {
    var viewController: ResetPasswordEmailSentViewControllerApi {
        return _viewController as! ResetPasswordEmailSentViewControllerApi
    }
    var interactor: ResetPasswordEmailSentInteractorApi {
        return _interactor as! ResetPasswordEmailSentInteractorApi
    }
    var router: ResetPasswordEmailSentRouterApi {
        return _router as! ResetPasswordEmailSentRouterApi
    }
}

fileprivate enum StringContants {
  static func emailSentStringFor(_ email: String) -> String {
    return "We've just sent an email to \"\(email)\""
  }
}
