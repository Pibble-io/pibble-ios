//
//  LanguagePickerInteractor.swift
//  Pibble-iOS
//
//  Created by Sergey Kazakov on 15/05/2019.
//Copyright © 2019 com.kazai. All rights reserved.
//

import Foundation 

// MARK: - LanguagePickerInteractor Class
final class LanguagePickerInteractor: Interactor {
  fileprivate let accountProfileService: AccountProfileServiceProtocol
  
  init(accountProfileService: AccountProfileServiceProtocol) {
    self.accountProfileService = accountProfileService
  }
}

// MARK: - LanguagePickerInteractor API
extension LanguagePickerInteractor: LanguagePickerInteractorApi {

}

// MARK: - Interactor Viper Components Api
private extension LanguagePickerInteractor {
  var presenter: LanguagePickerPresenterApi {
    return _presenter as! LanguagePickerPresenterApi
  }
}
