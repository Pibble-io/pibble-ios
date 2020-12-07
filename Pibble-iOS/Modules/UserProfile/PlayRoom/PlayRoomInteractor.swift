//
//  PlayRoomInteractor.swift
//  Pibble-iOS
//
//  Created by Sergey Kazakov on 20/05/2019.
//Copyright © 2019 com.kazai. All rights reserved.
//

import Foundation 

// MARK: - PlayRoomInteractor Class
final class PlayRoomInteractor: Interactor {
  fileprivate let accountProfileService: AccountProfileServiceProtocol
  fileprivate let userInteractionService: UserInteractionServiceProtocol
  fileprivate let playRoomType: PlayRoom.PlayRoomType
  
  init(userInteractionService: UserInteractionServiceProtocol,
       accountProfileService: AccountProfileServiceProtocol,
       playRoomType: PlayRoom.PlayRoomType) {
    self.userInteractionService = userInteractionService
    self.accountProfileService = accountProfileService
    self.playRoomType = playRoomType
  }
}

// MARK: - PlayRoomInteractor API
extension PlayRoomInteractor: PlayRoomInteractorApi {
  func intitialFetchData() {
    guard let currentUser = accountProfileService.currentUserAccount else {
      accountProfileService.getProfile { [weak self] in
        switch $0 {
        case .success(let accountProfile):
          self?.fetchUrlForCurrentUser(accountProfile)
        case .failure(let error):
          self?.presenter.handleError(error)
        }
      }
      return
    }
    
    fetchUrlForCurrentUser(currentUser)
  }
  
  fileprivate func fetchUrlForCurrentUser(_ currentUser: UserProtocol) {
    switch playRoomType {
    case .currentUser:
      fetchUserEmail(currentUser) { [weak self] in
        let url = PibbleAppEndpoints.playroomURLForCurrentUser($0, username: currentUser.userName)
        self?.presenter.presentURL(url, user: currentUser)
      }
    case .otherUser(let otherUser):
      fetchUserEmail(currentUser) { [weak self] currentUserEmail  in
        
        self?.fetchUserEmail(otherUser) { [weak self] otherUserEmail in
          let url = PibbleAppEndpoints.playroomURLForUserProfile(currentUserEmail, currentUsername: currentUser.userName, userEmail: otherUserEmail)
          self?.presenter.presentURL(url, user: otherUser)
        }
      }
    }
  }
  
  fileprivate func fetchUserEmail(_ user: UserProtocol, complete: @escaping (String) -> Void) {
    guard let userEmail = user.userEmail else {
      userInteractionService.getUser(username: user.userName) { [weak self] in
        switch $0 {
        case .success(let userProfile):
          complete(userProfile.userEmail ?? "")
        case .failure(let error):
          complete("")
          self?.presenter.handleError(error)
          return
        }
      }
      
      return
    }
    
    complete(userEmail)
  }
}

// MARK: - Interactor Viper Components Api
private extension PlayRoomInteractor {
  var presenter: PlayRoomPresenterApi {
    return _presenter as! PlayRoomPresenterApi
  }
}
