//
//  CommerceTypePickInteractor.swift
//  Pibble-iOS
//
//  Created by Sergey Kazakov on 15/05/2019.
//Copyright © 2019 com.kazai. All rights reserved.
//

import Foundation 

// MARK: - CommerceTypePickInteractor Class
final class CommerceTypePickInteractor: Interactor {
  fileprivate let accountProfileService: AccountProfileServiceProtocol
  
  init(accountProfileService: AccountProfileServiceProtocol) {
    self.accountProfileService = accountProfileService
  }
}

// MARK: - CommerceTypePickInteractor API
extension CommerceTypePickInteractor: CommerceTypePickInteractorApi {
  func performFetchCurrentUserAndPresentMyGoods() {
    guard let currentUser = accountProfileService.currentUserAccount else {
      accountProfileService.getProfile { [weak self] in
        switch $0 {
        case .success(let user):
          self?.presenter.presentMyGoodsForUser(user)
        case .failure(let error):
          self?.presenter.handleError(error)
        }
      }
      return
    }
    
    presenter.presentMyGoodsForUser(currentUser)
  }
  
  func performFetchCurrentUserAndPresentPurchasedGoods() {
    guard let currentUser = accountProfileService.currentUserAccount else {
      accountProfileService.getProfile { [weak self] in
        switch $0 {
        case .success(let user):
          self?.presenter.presentPurchasedGoodsForUser(user)
        case .failure(let error):
          self?.presenter.handleError(error)
        }
      }
      return
    }
    
    presenter.presentPurchasedGoodsForUser(currentUser)
  }
}

// MARK: - Interactor Viper Components Api
private extension CommerceTypePickInteractor {
  var presenter: CommerceTypePickPresenterApi {
    return _presenter as! CommerceTypePickPresenterApi
  }
}
