//
//  WalletReceiveInteractor.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 30.08.2018.
//Copyright © 2018 com.kazai. All rights reserved.
//

import Foundation 

// MARK: - WalletReceiveInteractor Class
final class WalletReceiveInteractor: Interactor {
  fileprivate let accountProfileService: AccountProfileServiceProtocol
  let availableCurrencies: [BalanceCurrency]
  
  init(accountProfileService: AccountProfileServiceProtocol, currencies: [BalanceCurrency]) {
    self.accountProfileService = accountProfileService
    self.availableCurrencies = currencies
  }
}

// MARK: - WalletReceiveInteractor API
extension WalletReceiveInteractor: WalletReceiveInteractorApi {
  var profile: AccountProfileProtocol? {
    return accountProfileService.currentUserAccount
  }
  
  func fetchInitialData() {
    presenter.presentUserProfile(accountProfileService.currentUserAccount)
    
    guard let _ = accountProfileService.currentUserAccount else {
      accountProfileService.getProfile { [weak self] in
        switch $0 {
        case .success(let profile):
          self?.presenter.presentUserProfile(profile)
        case .failure(let err):
          self?.presenter.handleError(err)
        }
      }
      return
    }
  }
}

// MARK: - Interactor Viper Components Api
private extension WalletReceiveInteractor {
    var presenter: WalletReceivePresenterApi {
        return _presenter as! WalletReceivePresenterApi
    }
}
