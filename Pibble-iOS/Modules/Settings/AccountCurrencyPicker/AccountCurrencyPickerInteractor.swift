//
//  AccountCurrencyPickerInteractor.swift
//  Pibble-iOS
//
//  Created by Sergey Kazakov on 15/05/2019.
//Copyright © 2019 com.kazai. All rights reserved.
//

import Foundation 

// MARK: - AccountCurrencyPickerInteractor Class
final class AccountCurrencyPickerInteractor: Interactor {
  fileprivate let accountProfileService: AccountProfileServiceProtocol
  
  init(accountProfileService: AccountProfileServiceProtocol) {
    self.accountProfileService = accountProfileService
  }
}

// MARK: - AccountCurrencyPickerInteractor API
extension AccountCurrencyPickerInteractor: AccountCurrencyPickerInteractorApi {

}

// MARK: - Interactor Viper Components Api
private extension AccountCurrencyPickerInteractor {
  var presenter: AccountCurrencyPickerPresenterApi {
    return _presenter as! AccountCurrencyPickerPresenterApi
  }
}
