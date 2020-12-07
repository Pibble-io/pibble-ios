//
//  ResetPasswordEmailSentModuleInteractor.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 25.06.2018.
//Copyright © 2018 com.kazai. All rights reserved.
//

import Foundation 

// MARK: - ResetPasswordEmailSentModuleInteractor Class
final class ResetPasswordEmailSentInteractor: Interactor {
  let email: ResetPasswordEmailProtocol
  
  init(email: ResetPasswordEmailProtocol) {
    self.email = email
  }
}

// MARK: - ResetPasswordEmailSentModuleInteractor API
extension ResetPasswordEmailSentInteractor: ResetPasswordEmailSentInteractorApi {
}

// MARK: - Interactor Viper Components Api
private extension ResetPasswordEmailSentInteractor {
    var presenter: ResetPasswordEmailSentPresenterApi {
        return _presenter as! ResetPasswordEmailSentPresenterApi
    }
}
