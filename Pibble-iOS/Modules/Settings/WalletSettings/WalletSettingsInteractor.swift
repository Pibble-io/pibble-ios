//
//  WalletSettingsInteractor.swift
//  Pibble-iOS
//
//  Created by Sergey Kazakov on 15/05/2019.
//Copyright © 2019 com.kazai. All rights reserved.
//

import Foundation 

// MARK: - WalletSettingsInteractor Class
final class WalletSettingsInteractor: Interactor {
  fileprivate let accountProfileService: AccountProfileServiceProtocol
  
  init(accountProfileService: AccountProfileServiceProtocol) {
    self.accountProfileService = accountProfileService
  }
}

// MARK: - WalletSettingsInteractor API
extension WalletSettingsInteractor: WalletSettingsInteractorApi {
  func performSetAccountCurrency(_ balanceCurrency: BalanceCurrency) {
    accountProfileService.updateAccountCurrency(balanceCurrency) { [weak self] in
      self?.initialRefreshData()
      guard let error = $0 else {
        return
      }
      
      self?.presenter.handleError(error)
    }
  }
  
  func initialFetchData() {
    if let currentUserAccount = accountProfileService.currentUserAccount {
      presenter.presentUserAccount(currentUserAccount)
    }
    
    initialRefreshData()
  }
  
  func initialRefreshData() {
    accountProfileService.getProfile { [weak self] in
      switch $0 {
      case .success(let currentUserAccount):
        self?.presenter.presentUserAccount(currentUserAccount)
      case .failure(let error):
        self?.presenter.handleError(error)
      }
    }
  }
}

// MARK: - Interactor Viper Components Api
private extension WalletSettingsInteractor {
  var presenter: WalletSettingsPresenterApi {
    return _presenter as! WalletSettingsPresenterApi
  }
}
