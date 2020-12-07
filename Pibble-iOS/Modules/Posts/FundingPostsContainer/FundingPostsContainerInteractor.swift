//
//  FundingPostsContainerInteractor.swift
//  Pibble-iOS
//
//  Created by Sergey Kazakov on 10/06/2019.
//Copyright © 2019 com.kazai. All rights reserved.
//

import Foundation 

// MARK: - FundingPostsContainerInteractor Class
final class FundingPostsContainerInteractor: Interactor {
  let currentUserProfile: AccountProfileProtocol
  
  init(currentUserProfile: AccountProfileProtocol) {
    self.currentUserProfile = currentUserProfile
  }
}

// MARK: - FundingPostsContainerInteractor API
extension FundingPostsContainerInteractor: FundingPostsContainerInteractorApi {
  
  
}

// MARK: - Interactor Viper Components Api
private extension FundingPostsContainerInteractor {
  var presenter: FundingPostsContainerPresenterApi {
    return _presenter as! FundingPostsContainerPresenterApi
  }
}
