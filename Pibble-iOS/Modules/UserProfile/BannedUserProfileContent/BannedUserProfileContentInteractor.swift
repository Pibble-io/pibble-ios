//
//  BannedUserProfileContentInteractor.swift
//  Pibble-iOS
//
//  Created by Sergey Kazakov on 31/05/2019.
//Copyright © 2019 com.kazai. All rights reserved.
//

import Foundation 

// MARK: - BannedUserProfileContentInteractor Class
final class BannedUserProfileContentInteractor: Interactor {
  let user: UserProtocol
  
  init(user: UserProtocol) {
    self.user = user
  }
}

// MARK: - BannedUserProfileContentInteractor API
extension BannedUserProfileContentInteractor: BannedUserProfileContentInteractorApi {
}

// MARK: - Interactor Viper Components Api
private extension BannedUserProfileContentInteractor {
  var presenter: BannedUserProfileContentPresenterApi {
    return _presenter as! BannedUserProfileContentPresenterApi
  }
}
