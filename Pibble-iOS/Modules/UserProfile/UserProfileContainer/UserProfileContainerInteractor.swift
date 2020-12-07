//
//  UserProfileContainerInteractor.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 05.11.2018.
//Copyright © 2018 com.kazai. All rights reserved.
//

import Foundation 

// MARK: - UserProfileContainerInteractor Class
final class UserProfileContainerInteractor: Interactor {
  fileprivate let userInteractionService: UserInteractionServiceProtocol
  fileprivate let coreDataStorageService: CoreDataStorageServiceProtocol
  fileprivate let authService: AuthServiceProtocol
  
  let targetUser: UserProfileContent.TargetUser
  
  fileprivate(set) var currentUser: UserProtocol?
  
  init(userInteractionService: UserInteractionServiceProtocol,
       coreDataStorageService: CoreDataStorageServiceProtocol,
       authService: AuthServiceProtocol,
       targetUser: UserProfileContent.TargetUser) {
    self.userInteractionService = userInteractionService
    self.coreDataStorageService = coreDataStorageService
    self.authService = authService
    self.targetUser = targetUser
  }
}

// MARK: - UserProfileContainerInteractor API
extension UserProfileContainerInteractor: UserProfileContainerInteractorApi {
  func performLogout() {
    authService.logout()
  }
  
  func performReportUser() {
    
  }
  
  func performMuteUser() {
    guard case let UserProfileContent.TargetUser.other(user) = targetUser else {
      return
    }
    
    let managedUser = UserManagedObject.replaceOrCreate(with: user, in: coreDataStorageService.viewContext)
     
    managedUser.setMuteState(true)
    coreDataStorageService.updateStorage(with: [managedUser])
    
    let completeBlock: CompleteHandler = { [weak self] in
      if let error = $0 {
        self?.presenter.handleError(error)
        return
      }
    }
    
    userInteractionService.setMuteUserSettingsOnMainFeed(user, muted: true, complete: completeBlock)
  }
  
  
  func initialFetchData() {
    let complete: ResultCompleteHandler<UserProtocol, PibbleError> = { [weak self] in
      switch $0 {
      case .success(let user):
        self?.currentUser = user
        self?.presenter.presentUser(user)
      case .failure(let error):
        self?.presenter.handleError(error)
      }
    }
    
    switch targetUser {
    case .current:
      userInteractionService.getCurrentUser(complete: complete)
    case .other(let user):
      presenter.presentUser(user)
      userInteractionService.getUser(username: user.userName, complete: complete)
    }
  }
}

// MARK: - Interactor Viper Components Api
private extension UserProfileContainerInteractor {
    var presenter: UserProfileContainerPresenterApi {
        return _presenter as! UserProfileContainerPresenterApi
    }
}
