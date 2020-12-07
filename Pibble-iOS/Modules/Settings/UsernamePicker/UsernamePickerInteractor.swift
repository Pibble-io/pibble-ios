//
//  UsernamePickerInteractor.swift
//  Pibble-iOS
//
//  Created by Sergey Kazakov on 21/05/2019.
//Copyright © 2019 com.kazai. All rights reserved.
//

import Foundation 

// MARK: - UsernamePickerInteractor Class
final class UsernamePickerInteractor: Interactor {
  fileprivate let userProfileService: AccountProfileServiceProtocol
  fileprivate var usernameValue: String = ""
  
  init(userProfileService: AccountProfileServiceProtocol) {
    self.userProfileService = userProfileService
  }
}

// MARK: - UsernamePickerInteractor API
extension UsernamePickerInteractor: UsernamePickerInteractorApi {
  func initialFetchData() {
    if let profile = userProfileService.currentUserAccount {
      usernameValue = profile.userName
      presenter.presentUsername(profile.userName)
    }
    
    initialRefreshData()
  }
  
  func initialRefreshData() {
    userProfileService.getProfile { [weak self] in
      switch $0 {
      case .success(let profile):
        self?.usernameValue = profile.userName
        self?.presenter.presentUsername(profile.userName)
      case .failure(let error):
        self?.presenter.handleError(error)
      }
    }
  }
  
  
  func setUsernameValue(_ text: String) {
    usernameValue = text
  }
  
  func performUsernameChange() {
    userProfileService.updateUsername(username: usernameValue) { [weak self] in
      guard let strongSelf = self else {
        return
      }
      
      guard let error = $0 else {
        strongSelf.userProfileService.getProfile { [weak self] in
          switch $0 {
          case .success(_):
            self?.presenter.presentUsernameChangeSuccess()
          case .failure(let error):
            self?.presenter.handleError(error)
          }
        }
        return
      }
      
      strongSelf.presenter.handleError(error)
      strongSelf.presenter.presentUsername(strongSelf.usernameValue)
    }
  }
}

// MARK: - Interactor Viper Components Api
private extension UsernamePickerInteractor {
  var presenter: UsernamePickerPresenterApi {
    return _presenter as! UsernamePickerPresenterApi
  }
}
