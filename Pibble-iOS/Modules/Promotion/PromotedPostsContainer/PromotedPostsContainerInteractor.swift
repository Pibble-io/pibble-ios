//
//  PromotedPostsContainerInteractor.swift
//  Pibble-iOS
//
//  Created by Sergey Kazakov on 10/06/2019.
//Copyright © 2019 com.kazai. All rights reserved.
//

import Foundation 

// MARK: - PromotedPostsContainerInteractor Class
final class PromotedPostsContainerInteractor: Interactor {
  let currentUserProfile: AccountProfileProtocol
  
  init(currentUserProfile: AccountProfileProtocol) {
    self.currentUserProfile = currentUserProfile
  }
}

// MARK: - PromotedPostsContainerInteractor API
extension PromotedPostsContainerInteractor: PromotedPostsContainerInteractorApi {
  
  
}

// MARK: - Interactor Viper Components Api
private extension PromotedPostsContainerInteractor {
  var presenter: PromotedPostsContainerPresenterApi {
    return _presenter as! PromotedPostsContainerPresenterApi
  }
}
