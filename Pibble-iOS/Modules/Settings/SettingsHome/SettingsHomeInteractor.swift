//
//  SettingsHomeInteractor.swift
//  Pibble-iOS
//
//  Created by Sergey Kazakov on 15/05/2019.
//Copyright © 2019 com.kazai. All rights reserved.
//

import Foundation 

// MARK: - SettingsHomeInteractor Class
final class SettingsHomeInteractor: Interactor {
  fileprivate let accountProfileService: AccountProfileServiceProtocol
  fileprivate let authService: AuthServiceProtocol
  
  init(accountProfileService: AccountProfileServiceProtocol, authService: AuthServiceProtocol) {
    self.accountProfileService = accountProfileService
    self.authService = authService
  }
}



// MARK: - SettingsHomeInteractor API
extension SettingsHomeInteractor: SettingsHomeInteractorApi {
  func performFetchCurrentUserAndPresentPromotions() {
    guard let currentUser = accountProfileService.currentUserAccount else {
      accountProfileService.getProfile { [weak self] in
        switch $0 {
        case .success(let user):
          self?.presenter.presentPromotionsForUser(user)
        case .failure(let error):
          self?.presenter.handleError(error)
        }
      }
      return
    }
    
    presenter.presentPromotionsForUser(currentUser)
  }
  
  func performFetchCurrentUserAndPresentFundings() {
    guard let currentUser = accountProfileService.currentUserAccount else {
      accountProfileService.getProfile { [weak self] in
        switch $0 {
        case .success(let user):
          self?.presenter.presentFundingsForUser(user)
        case .failure(let error):
          self?.presenter.handleError(error)
        }
      }
      return
    }
    
    presenter.presentFundingsForUser(currentUser)
  }
  
  func performLogout() {
    authService.logout()
  }
  
  func performFetchCurrentUserAndPresentInviteFriends() {
    guard let currentUser = accountProfileService.currentUserAccount else {
      accountProfileService.getProfile { [weak self] in
        switch $0 {
        case .success(let user):
          self?.presenter.presentInviteFriendsForUser(user)
        case .failure(let error):
          self?.presenter.handleError(error)
        }
      }
      return
    }
    
    presenter.presentInviteFriendsForUser(currentUser)
  }
  
  func performFetchCurrentUserAndPresentEditFriends() {
    guard let currentUser = accountProfileService.currentUserAccount else {
      accountProfileService.getProfile { [weak self] in
        switch $0 {
        case .success(let user):
          self?.presenter.presentFriendsForUser(user)
        case .failure(let error):
          self?.presenter.handleError(error)
        }
      }
      return
    }
    
    presenter.presentFriendsForUser(currentUser)
  }
}

// MARK: - Interactor Viper Components Api
private extension SettingsHomeInteractor {
  var presenter: SettingsHomePresenterApi {
    return _presenter as! SettingsHomePresenterApi
  }
}
