//
//  UserProfileContentInteractor.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 05.11.2018.
//Copyright © 2018 com.kazai. All rights reserved.
//

import Foundation
import Photos

// MARK: - UserProfileContentInteractor Class
final class UserProfileContentInteractor: Interactor {
  fileprivate let userInteractionService: UserInteractionServiceProtocol
  fileprivate let storageService: CoreDataStorageServiceProtocol
  fileprivate let mediaLibraryExportService: MediaLibraryExportServiceProtocol
  fileprivate let accountProfileService: AccountProfileServiceProtocol
  
  fileprivate var rewardsHistoryPeriod: RewardsHistoryPeriod = .year
  fileprivate let targetUser: UserProfileContent.TargetUser
  
  fileprivate(set) var user: UserProtocol? {
    get {
      return managedUser
    }
    
    set {
      if let updatedUser = newValue {
        managedUser = UserManagedObject.replaceOrCreate(with: updatedUser, in: storageService.viewContext)
      }
    }
  }
  
  fileprivate var managedUser: UserManagedObject?
  
  fileprivate var userFriends: [UserProtocol] = []
  fileprivate var userFriendshipRequests: [UserManagedObject] = []
  
  fileprivate let friendsPreviewRequestPage = 0
  fileprivate let friendsPreviewRequestItems = 3
  
  init(userInteractionService: UserInteractionServiceProtocol,
       storageService: CoreDataStorageServiceProtocol,
       mediaLibraryExportService: MediaLibraryExportServiceProtocol,
       accountProfileService: AccountProfileServiceProtocol,
       targetUser: UserProfileContent.TargetUser) {
    self.userInteractionService = userInteractionService
    self.storageService = storageService
    self.mediaLibraryExportService = mediaLibraryExportService
    self.accountProfileService = accountProfileService
    self.targetUser = targetUser
  }
}

// MARK: - UserProfileContentInteractor API
extension UserProfileContentInteractor: UserProfileContentInteractorApi {
  func performSwitchChartPeriodAction() {
    switch rewardsHistoryPeriod {
    case .year:
      rewardsHistoryPeriod = .week
    case .week:
      rewardsHistoryPeriod = .year
    }
    
    fetchBrushRewardsHistory(pediod: rewardsHistoryPeriod)
  }
  
  func friendUserAt(_ index: Int) -> UserProtocol? {
    guard index < userFriends.count else {
      return nil
    }
    let user = userFriends[index]
    return user
  }
  
  func friendRequestUserAt(_ index: Int) -> UserProtocol? {
    guard index < userFriendshipRequests.count else {
      return nil
    }
    let user = userFriendshipRequests[index]
    return user
  }
  
  func denyFriendRequestActionFor(_ index: Int) {
    guard index < userFriendshipRequests.count else {
      return
    }
    let user = userFriendshipRequests[index]
    
    user.isFriendshipDenied = true
    
    userInteractionService.rejectFriendship(user: user) { [weak self] in
      guard let strongSelf = self else {
        return
      }
      guard let error = $0 else {
        strongSelf.presenter.presentReloadFriendsRequestsFor(strongSelf.userFriendshipRequests)
        return
      }
      user.isFriendshipDenied = false
      self?.presenter.handleError(error)
    }
  }
  
  func acceptFriendRequestActionFor(_ index: Int) {
    guard index < userFriendshipRequests.count else {
      return
    }
    let user = userFriendshipRequests[index]
    
    user.isFriend = true
    
    userInteractionService.acceptFriendship(user: user) { [weak self] in
      guard let strongSelf = self else {
        return
      }
      guard let error = $0 else {
        strongSelf.presenter.presentReloadFriendsRequestsFor(strongSelf.userFriendshipRequests)
        return
      }
      
      user.isFriend = false
      self?.presenter.handleError(error)
    }
  }
  
  func updateUserProfile(_ profile: UserProfileProtocol) {
    accountProfileService.updateUserProfile(profile) { [weak self] in
      guard let error = $0 else {
        self?.initialRefreshData()
        return
      }
      self?.presenter.handleError(error)
    }
  }
  
  func uploadUserpicFromAsset(_ asset: LibraryAsset) {
    mediaLibraryExportService.exportAssetForUserpicPurpose(asset) { [weak self] in
      switch $0 {
      case .success(let assetUrl):
        self?.uploadUserpickFromFileURL(assetUrl)
      case .failure(let error):
        self?.presenter.handleError(error)
      }
    }
  }
  
  func uploadWallFromAsset(_ asset: LibraryAsset) {
    mediaLibraryExportService.exportAssetForWallPurpose(asset) { [weak self] in
      switch $0 {
      case .success(let assetUrl):
        self?.uploadWallCoverFromFileURL(assetUrl)
      case .failure(let error):
        self?.presenter.handleError(error)
      }
    }
  }
  
  fileprivate func uploadUserpickFromFileURL(_ url: URL) {
    accountProfileService.updateUserpic(imageFileURL: url) { [weak self] in
      guard let error = $0 else {
        self?.initialRefreshData()
        return
      }
      self?.presenter.handleError(error)
    }
  }
  
  fileprivate func uploadWallCoverFromFileURL(_ url: URL) {
    accountProfileService.updateWallCover(imageFileURL: url) { [weak self] in
      guard let error = $0 else {
        self?.initialRefreshData()
        return
      }
      self?.presenter.handleError(error)
    }
  }
  
  func performFollowingAction() {
    guard let user = managedUser else {
      return
    }
    
    guard !(user.isCurrent ?? false) else {
      return
    }
  
    let isFollowedByCurrentUser = user.isFollowedByMe
    let followersChange: Int32 = isFollowedByCurrentUser ? -1 : 1
    
    user.isFollowedByMe = !isFollowedByCurrentUser
    user.followersCount += followersChange
    
    user.mediaPostings?.forEach {
      if let usersPosting = ($0 as? PostingManagedObject),
        !usersPosting.isFault {
        usersPosting.triggerRefresh()
      }
    }
    
    presenter.presentReloadInfoFor(user)
    
    let complete: CompleteHandler = { [weak self] (err) in
      if let error = err {
        self?.presenter.handleError(error)
        user.isFollowedByMe = isFollowedByCurrentUser
        user.followersCount -= followersChange
        
        user.mediaPostings?.forEach {
          if let usersPosting = ($0 as? PostingManagedObject),
            !usersPosting.isFault {
            usersPosting.triggerRefresh()
          }
        }
        self?.presenter.presentReloadInfoFor(user)
        return
      }
      
      self?.initialRefreshData()
    }
    
    isFollowedByCurrentUser ?
      userInteractionService.unfollow(user: user, complete: complete) :
      userInteractionService.follow(user: user, complete: complete)
  }
  
  func performFriendshipAction() {
    guard let user = managedUser else {
      return
    }
    
    guard !(user.isCurrent ?? false) else {
      return
    }
    
    guard !user.isFriendWithCurrentUser else {
      return
    }
    
    guard !user.isOutboundFriendshipRequested else {
      return
    }
    
    let isFriendOldState = user.isFriend
    let isOutboundFriendRequestedOldState = user.isOutboundFriendRequested
    let friendsCountOldState = user.friendsCount
    
    let complete: CompleteHandler =  { [weak self] (err) in
      if let error = err {
        user.isFriend = isFriendOldState
        user.isOutboundFriendRequested = isOutboundFriendRequestedOldState
        user.friendsCount = friendsCountOldState
        
        self?.presenter.presentReloadInfoFor(user)
        self?.presenter.handleError(error)
        return
      }
      
      self?.initialRefreshData()
    }
    
    guard !user.isInboundFriendshipRequested else {
      user.isFriend = true
      user.friendsCount += 1
      presenter.presentReloadInfoFor(user)
      userInteractionService.acceptFriendship(user: user, complete: complete)
      return
    }
    user.isOutboundFriendRequested = true
    presenter.presentReloadInfoFor(user)
    userInteractionService.requestFriendship(user: user, complete: complete)
  }
  
  fileprivate func fetchBrushRewardsHistory(pediod: RewardsHistoryPeriod) {
    let complete: ResultCompleteHandler<(prb: [HistoricalDataPointProtocol], pgb: [HistoricalDataPointProtocol]), PibbleError> = { [weak self] in
      
      guard let strongSelf = self else {
        return
      }
      
      switch $0 {
      case .success(let prb, let pgb):
        DispatchQueue.global(qos: .utility).async { [weak self] in
          guard let strongSelf = self else {
            return
          }
          let rewardsHistory = UserProfileContent.BrushRewardsHistory.mergedDailyRewards(pgb: pgb, prb: prb, period: pediod)
          DispatchQueue.main.async {
            strongSelf.presenter.presentReloadHistoryRewards(rewardsHistory)
            strongSelf.fetchFriendsRequests()
          }
        }
        
      case .failure(let error):
        strongSelf.presenter.handleError(error)
      }
    }
    
    switch targetUser {
    case .current:
      userInteractionService.getCurrentUserRewardsHistory(period: pediod, complete: complete)
    case .other(let user):
      userInteractionService.getRewardsHistory(username: user.userName, period: pediod, complete: complete)
    }
  }
  
  fileprivate func fetchFriendsRequests() {
    let complete: ResultCompleteHandler<([PartialUserProtocol], PaginationInfoProtocol), PibbleError> = { [weak self] in
      guard let strongSelf = self else {
        return
      }
      switch $0 {
      case .success(let response):
        let managedUsers = response.0.map { return UserManagedObject.updateOrCreate(with: $0, in: strongSelf.storageService.viewContext) }
        strongSelf.userFriendshipRequests = managedUsers
        self?.presenter.presentReloadFriendsRequestsFor(managedUsers)
      case .failure(let error):
        self?.presenter.handleError(error)
      }
    }
    
    switch targetUser {
    case .current:
      userInteractionService.getFriendshipRequestsForCurrentUser(page: friendsPreviewRequestPage, perPage: friendsPreviewRequestItems, complete: complete)
    case .other(_):
      presenter.presentReloadFriendsRequestsFor([])
    }
  }
  
  fileprivate func fetchFriends() {
    let period = rewardsHistoryPeriod
    let complete: ResultCompleteHandler<([PartialUserProtocol], PaginationInfoProtocol), PibbleError> = { [weak self] in
      guard let strongSelf =  self else {
        return
      }
      
      switch $0 {
      case .success(let response):
        let managedUsers = response.0.map { return UserManagedObject.updateOrCreate(with: $0, in: strongSelf.storageService.viewContext) }
        strongSelf.userFriends = managedUsers
        strongSelf.presenter.presentReloadFriendsFor(managedUsers)
        strongSelf.fetchBrushRewardsHistory(pediod: period)
      case .failure(let error):
        strongSelf.presenter.handleError(error)
      }
    }
    
    switch targetUser {
    case .current:
      userInteractionService.getFriendsForCurrentUser(page: friendsPreviewRequestPage, perPage: friendsPreviewRequestItems, complete: complete)
    case .other(let user):
      userInteractionService.getFriendsForUser(username: user.userName, page: friendsPreviewRequestPage, perPage: friendsPreviewRequestItems, complete: complete)
    }
  }
  
  func initialRefreshData() {
    AppLogger.debug("initialRefreshData")
    let complete: ResultCompleteHandler<UserProtocol, PibbleError> = { [weak self] in
      switch $0 {
      case .success(let user):
        self?.user = user
        self?.presenter.presentReloadInfoFor(user)
        
        self?.fetchFriends()
      case .failure(let error):
        self?.presenter.handleError(error)
      }
    }
    
    switch targetUser {
    case .current:
      userInteractionService.getCurrentUser(complete: complete)
    case .other(let user):
      userInteractionService.getUser(username: user.userName, complete: complete)
    }
  }
  
  func initialFetchData() {
    switch targetUser {
    case .current:
      break
    case .other(let user):
      self.user = user
      presenter.presentReloadInfoFor(user)
    }
  }
}

// MARK: - Interactor Viper Components Api
private extension UserProfileContentInteractor {
  var presenter: UserProfileContentPresenterApi {
    return _presenter as! UserProfileContentPresenterApi
  }
}
