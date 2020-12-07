//
//  WalletPreviewInteractor.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 15.10.2018.
//Copyright © 2018 com.kazai. All rights reserved.
//

import Foundation 

// MARK: - WalletPreviewInteractor Class
final class WalletPreviewInteractor: Interactor {
  fileprivate let accountProfileService: AccountProfileServiceProtocol
  
  init(accountProfileService: AccountProfileServiceProtocol) {
    self.accountProfileService = accountProfileService
  }
}

// MARK: - WalletPreviewInteractor API
extension WalletPreviewInteractor: WalletPreviewInteractorApi {
  func initialFetchData() {
    accountProfileService.getProfile { [weak self] in
      switch $0 {
      case .success(_):
        self?.accountProfileService.getAccountUpvoteLimits { [weak self] in
          switch $0 {
          case .success(_):
            self?.presenter.presentReload()
          case .failure(let error):
            self?.presenter.handleError(error)
          }
        }
      case .failure(let error):
        self?.presenter.handleError(error)
      }
    }
  }
  
  var currentUserAccount: (account: AccountProfileProtocol?, limits: AccountUpvoteLimitsProtocol?) {
    return (accountProfileService.currentUserAccount, accountProfileService.currentAccountUpvoteLimits)
  }
}

// MARK: - Interactor Viper Components Api
private extension WalletPreviewInteractor {
    var presenter: WalletPreviewPresenterApi {
        return _presenter as! WalletPreviewPresenterApi
    }
}
