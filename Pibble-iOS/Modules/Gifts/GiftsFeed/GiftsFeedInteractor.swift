//
//  GiftsFeedInteractor.swift
//  Pibble-iOS
//
//  Created by Sergey Kazakov on 20/05/2019.
//Copyright © 2019 com.kazai. All rights reserved.
//

import Foundation 

// MARK: - GiftsFeedInteractor Class
final class GiftsFeedInteractor: Interactor {
  fileprivate let accountProfileService: AccountProfileServiceProtocol
  let contentType: GiftsFeed.ContentType
  
  init(accountProfileService: AccountProfileServiceProtocol, contentType: GiftsFeed.ContentType) {
    self.accountProfileService = accountProfileService
    self.contentType = contentType
  }
}

// MARK: - GiftsFeedInteractor API
extension GiftsFeedInteractor: GiftsFeedInteractorApi {
  func intitialFetchData() {
    switch contentType {
    case .giftHome:
      fetchHomeUrl()
    case .giftSearch:
      fetchSearchUrl()
    }
  }
  
  fileprivate func fetchHomeUrl() {
    guard let profile = accountProfileService.currentUserAccount else {
      accountProfileService.getProfile { [weak self] in
        switch $0 {
        case .success(let userProfile):
          let url = PibbleAppEndpoints.giftsHomeUrlFor(userProfile.accountProfileEmail, username: userProfile.userName)
          self?.presenter.presentURL(url)
        case .failure(let error):
          self?.presenter.handleError(error)
          return
        }
      }
      
      return
    }
    
    let url = PibbleAppEndpoints.giftsHomeUrlFor(profile.accountProfileEmail,
                                                 username: profile.userName)
    presenter.presentURL(url)
  }
  
  fileprivate func fetchSearchUrl() {
    guard let profile = accountProfileService.currentUserAccount else {
      accountProfileService.getProfile { [weak self] in
        switch $0 {
        case .success(let userProfile):
          let url = PibbleAppEndpoints.giftsSearchUrlFor(userProfile.accountProfileEmail, username: userProfile.userName)
          self?.presenter.presentURL(url)
        case .failure(let error):
          self?.presenter.handleError(error)
          return
        }
      }
      
      return
    }
    
    let url = PibbleAppEndpoints.giftsSearchUrlFor(profile.accountProfileEmail, username: profile.userName)
    presenter.presentURL(url)
  }
}

// MARK: - Interactor Viper Components Api
private extension GiftsFeedInteractor {
  var presenter: GiftsFeedPresenterApi {
    return _presenter as! GiftsFeedPresenterApi
  }
}
