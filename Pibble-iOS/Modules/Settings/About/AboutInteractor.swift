//
//  AboutInteractor.swift
//  Pibble-iOS
//
//  Created by Sergey Kazakov on 15/05/2019.
//Copyright © 2019 com.kazai. All rights reserved.
//

import Foundation 

// MARK: - AboutInteractor Class
final class AboutInteractor: Interactor {
  fileprivate let accountProfileService: AccountProfileServiceProtocol
  
  init(accountProfileService: AccountProfileServiceProtocol) {
    self.accountProfileService = accountProfileService
  }
}

// MARK: - AboutInteractor API
extension AboutInteractor: AboutInteractorApi {
  var termsURL: URL {
    return PibbleAppEndpoints.termsUrl
  }
  
  var privacyPolicyURL: URL {
    return PibbleAppEndpoints.privacyPolicyUrl
  }
  
  var communityGuideURL: URL {
    return PibbleAppEndpoints.communityGuideUrl
  }
  
  var appVersion: String {
    if let text = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
      return text
    }
    
    return "1.0"
  }
  
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
private extension AboutInteractor {
  var presenter: AboutPresenterApi {
    return _presenter as! AboutPresenterApi
  }
}
