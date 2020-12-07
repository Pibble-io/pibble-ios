//
//  WalletHomeInteractor.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 23.08.2018.
//Copyright © 2018 com.kazai. All rights reserved.
//

import Foundation 

// MARK: - WalletHomeInteractor Class
final class WalletHomeInteractor: Interactor {
  fileprivate let accountProfileService: AccountProfileServiceProtocol
  fileprivate let walletService: WalletServiceProtocol
  fileprivate var walletRequestedUnlock = false
  
  init(accountProfileService: AccountProfileServiceProtocol, walletService: WalletServiceProtocol) {
    self.accountProfileService = accountProfileService
    self.walletService = walletService
  }
}

// MARK: - WalletHomeInteractor API
extension WalletHomeInteractor: WalletHomeInteractorApi {
  var userProfile: AccountProfileProtocol? {
    return accountProfileService.currentUserAccount
  }
  
  var hasPinCode: Bool {
    return walletService.hasPinCode
  }
  
  func fetchInitialData() {
    accountProfileService.getProfile { [weak self] in
      guard let strongSelf = self else {
        return
      }
      switch $0 {
      case .success(let userProfile):
        strongSelf.presenter.presentUserProfile(userProfile)
      case .failure(let err):
        strongSelf.presenter.handleError(err)
      }
    }
  }
  
}

// MARK: - Interactor Viper Components Api
private extension WalletHomeInteractor {
    var presenter: WalletHomePresenterApi {
        return _presenter as! WalletHomePresenterApi
    }
}
