//
//  AccountSettingsInteractor.swift
//  Pibble-iOS
//
//  Created by Sergey Kazakov on 15/05/2019.
//Copyright © 2019 com.kazai. All rights reserved.
//

import Foundation 

// MARK: - AccountSettingsInteractor Class
final class AccountSettingsInteractor: Interactor {
  fileprivate let accountProfileService: AccountProfileServiceProtocol
  fileprivate let appSettingsService: AppSettingsServiceProtocol
  
  init(accountProfileService: AccountProfileServiceProtocol,
       appSettingsService: AppSettingsServiceProtocol) {
    self.accountProfileService = accountProfileService
    self.appSettingsService = appSettingsService
  }
}

// MARK: - AccountSettingsInteractor API
extension AccountSettingsInteractor: AccountSettingsInteractorApi {
  var appLanguageSettings: AppLanguage {
    get {
      return appSettingsService.appLanguage
    }
    set {
      appSettingsService.appLanguage = newValue
    }
  }
  
  
  func performFetchCurrentUserAndPresentMutedUsers() {
    guard let currentUser = accountProfileService.currentUserAccount else {
      accountProfileService.getProfile { [weak self] in
        switch $0 {
        case .success(let user):
          self?.presenter.presentMutedUsersForUser(user)
        case .failure(let error):
          self?.presenter.handleError(error)
        }
      }
      return
    }
    
    presenter.presentMutedUsersForUser(currentUser)
  }
}

// MARK: - Interactor Viper Components Api
private extension AccountSettingsInteractor {
  var presenter: AccountSettingsPresenterApi {
    return _presenter as! AccountSettingsPresenterApi
  }
}
