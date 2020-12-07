//
//  FundingPostDetailInteractor.swift
//  Pibble-iOS
//
//  Created by Sergey Kazakov on 06/02/2019.
//Copyright © 2019 com.kazai. All rights reserved.
//

import Foundation 

// MARK: - FundingPostDetailInteractor Class
final class FundingPostDetailInteractor: Interactor {
  fileprivate let chatService: ChatServiceProtocol
  fileprivate let accountProfileService: AccountProfileServiceProtocol
  fileprivate let coreDataStorage: CoreDataStorageServiceProtocol
  fileprivate let postingService: PostingServiceProtocol
  
  fileprivate(set) var post: PostingProtocol
  
  init(chatService: ChatServiceProtocol,
       accountProfileService: AccountProfileServiceProtocol,
       coreDataStorage: CoreDataStorageServiceProtocol,
       postingService: PostingServiceProtocol,
       post: PostingProtocol) {
    self.chatService = chatService
    self.accountProfileService = accountProfileService
    self.coreDataStorage = coreDataStorage
    self.postingService = postingService
    self.post = post
  }
}

// MARK: - FundingPostDetailInteractor API
extension FundingPostDetailInteractor: FundingPostDetailInteractorApi {
  func fetchInitialData() {
    guard let currrentUser = accountProfileService.currentUserAccount else {
      accountProfileService.getProfile { [weak self] in
        guard let strongSelf = self else {
          return
        }
        
        switch $0 {
        case .success(let userProfile):
          strongSelf.presenter.presentPost(strongSelf.post, currentUser: userProfile)
        case .failure(let error):
          strongSelf.presenter.handleError(error)
        }
      }
      
      return
    }
   
    presenter.presentPost(post, currentUser: currrentUser)
  }
  
//  func performDonateAt(_ withBalance: BalanceProtocol, donatePrice: Double?) {
//    let completeBlock: CompleteHandler = { [weak self] in
//      if let err = $0 {
//        self?.presenter.handleError(err)
//        return
//      }
//      
//      self?.postingService.showPosting(postId: post.identifier) { [weak self] in
//        switch $0 {
//        case .success(let posting):
//          guard let strongSelf = self else {
//            return
//          }
//          
//          strongSelf.coreDataStorage.updateStorage(with: [posting])
//          strongSelf.post = posting
//          strongSelf.fetchInitialData()
//          
//        case .failure(let error):
//          self?.presenter.handleError(error)
//        }
//      }
//    }
//    
//    postingService.donate(postId: post.identifier, amount: Int(withBalance.value), currency: withBalance.currency, donatePrice: donatePrice, complete: completeBlock)
//  }
}

// MARK: - Interactor Viper Components Api
private extension FundingPostDetailInteractor {
  var presenter: FundingPostDetailPresenterApi {
    return _presenter as! FundingPostDetailPresenterApi
  }
}
