//
//  TopBannerInfoInteractor.swift
//  Pibble-iOS
//
//  Created by Sergey Kazakov on 20/05/2019.
//Copyright © 2019 com.kazai. All rights reserved.
//

import Foundation 

// MARK: - TopBannerInfoInteractor Class
final class TopBannerInfoInteractor: Interactor {
  let accountProfileService: AccountProfileServiceProtocol
  
  init(accountProfileService: AccountProfileServiceProtocol) {
    self.accountProfileService = accountProfileService
  }
}

// MARK: - TopBannerInfoInteractor API
extension TopBannerInfoInteractor: TopBannerInfoInteractorApi {
  func initialFetchData() {
    guard let userAccount = accountProfileService.currentUserAccount else {
      accountProfileService.getProfile { [weak self] in
        switch $0 {
        case .success(let account):
          let url = PibbleAppEndpoints.topBannerInfoURL(account.userEmail ?? "", username: account.userName)
          self?.presenter.presentUrl(url)
        case .failure(let error):
          self?.presenter.handleError(error)
        }
      }
      
      return
    }
    
    let url = PibbleAppEndpoints.topBannerInfoURL(userAccount.userEmail ?? "", username: userAccount.userName)
    presenter.presentUrl(url)
  }
}

// MARK: - Interactor Viper Components Api
private extension TopBannerInfoInteractor {
  var presenter: TopBannerInfoPresenterApi {
    return _presenter as! TopBannerInfoPresenterApi
  }
}
