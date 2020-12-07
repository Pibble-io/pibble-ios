//
//  UsersListingInteractor.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 10.11.2018.
//Copyright © 2018 com.kazai. All rights reserved.
//

import Foundation 
import CoreData

// MARK: - UsersListingInteractor Class
final class UsersListingInteractor: Interactor {
  let contentType: UsersListing.ContentType
  
  fileprivate let coreDataStorage: CoreDataStorageServiceProtocol
  fileprivate let userInteractionService: UserInteractionServiceProtocol
  fileprivate let tagService: TagServiceProtocol
  
  fileprivate var paginationController: PaginationControllerProtocol
  
  fileprivate lazy var fetchedResultsControllerDelegateProxy: FetchedResultsControllerDelegateProxy = {
    FetchedResultsControllerDelegateProxy(delegate: self)
  }()
  
  fileprivate lazy var fetchResultController: NSFetchedResultsController<UserManagedObject> = {
    let fetchRequest: NSFetchRequest<UserManagedObject> = UserManagedObject.fetchRequest()
    fetchRequest.predicate = fetchPredicate()
    fetchRequest.sortDescriptors = sortDesriptors()
    fetchRequest.fetchBatchSize = 30
    
    let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: coreDataStorage.viewContext, sectionNameKeyPath: nil, cacheName: nil)
    
    fetchedResultsController.delegate = fetchedResultsControllerDelegateProxy
    return fetchedResultsController
  }()
  
  init(coreDataStorage: CoreDataStorageServiceProtocol,
       userInteractionService: UserInteractionServiceProtocol,
       tagService: TagServiceProtocol,
       filterType: UsersListing.ContentType) {
    self.coreDataStorage = coreDataStorage
    self.userInteractionService = userInteractionService
    self.tagService = tagService
    
    self.contentType = filterType
    
    self.paginationController = PaginationController(itemsPerPage: 10, requestItems: 10, shouldRefreshTop: false, shouldRefreshInTheMiddle: false)
    
    super.init()
    self.paginationController.delegate = self
  }
}

// MARK: - UsersListingInteractor API
extension UsersListingInteractor: UsersListingInteractorApi {
  func performUnmuteActionAt(_ indexPath: IndexPath) {
    guard case let UsersListing.ContentType.mutedUsers(currentUser) = contentType else {
      return
    }
    
    let user = fetchResultController.object(at: indexPath)
    
    guard !(user.isCurrent ?? false) else {
      return
    }
    
    let managedCurrentUser = UserManagedObject.replaceOrCreate(with: currentUser, in: coreDataStorage.viewContext)
    let relation = UserRelations.muted(user, by: managedCurrentUser)
    coreDataStorage.removeFromStorage(objects: [relation])
    
    let complete: CompleteHandler = { [weak self] (err) in
      guard let error = err else {
        return
      }
      
      self?.presenter.handleError(error)
    }
    
    userInteractionService.setMuteUserSettingsOnMainFeed(user, muted: false, complete: complete)
  }
  
  func performCancelFriendshipActionAt(_ indexPath: IndexPath) {
    guard case let UsersListing.ContentType.editFriends(currentUser) = contentType else {
      return
    }
    
    let user = fetchResultController.object(at: indexPath)
    
    guard !(user.isCurrent ?? false) else {
      return
    }
    
    let friendsCountChange: Int32 = -1
    
    user.isFriend = false
    user.friendsCount += friendsCountChange
    
    let managedCurrentUser = UserManagedObject.replaceOrCreate(with: currentUser, in: coreDataStorage.viewContext)
    user.removeFromFriends(managedCurrentUser)
    coreDataStorage.updateStorage(with: [user])
    
    user.mediaPostings?.forEach {
      if let usersPosting = ($0 as? PostingManagedObject),
        !usersPosting.isFault {
        usersPosting.triggerRefresh()
      }
    }
    
    let complete: CompleteHandler = { [weak self] (err) in
      guard let error = err else {
        return
      }
      
      self?.presenter.handleError(error)
      user.isFollowedByMe = true
      user.followersCount -= friendsCountChange
      
      user.mediaPostings?.forEach {
        if let usersPosting = ($0 as? PostingManagedObject),
          !usersPosting.isFault {
          usersPosting.triggerRefresh()
        }
      }
    }
    
    userInteractionService.cancelFriendship(user: user, complete: complete)
  }
  
  func performFollowingActionAt(_ indexPath: IndexPath) {
    let user = fetchResultController.object(at: indexPath)
    
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
    
    let complete: CompleteHandler = { [weak self] (err) in
      guard let error = err else {
        return
      }
      
      self?.presenter.handleError(error)
      user.isFollowedByMe = isFollowedByCurrentUser
      user.followersCount -= followersChange
      
      user.mediaPostings?.forEach {
        if let usersPosting = ($0 as? PostingManagedObject),
          !usersPosting.isFault {
          usersPosting.triggerRefresh()
        }
      }
    }
    
    isFollowedByCurrentUser ?
      userInteractionService.unfollow(user: user, complete: complete) :
      userInteractionService.follow(user: user, complete: complete)
  }
  
  func numberOfSections() -> Int {
    return fetchResultController.sections?.count ?? 0
  }
  
  func numberOfItemsInSection(_ section: Int) -> Int {
    return fetchResultController.sections?[section].numberOfObjects ?? 0
  }
  
  func itemAt(_ indexPath: IndexPath) -> UserProtocol {
    return fetchResultController.object(at: indexPath)
  }
  
  func prepareItemFor(_ indexPath: Int) {
    paginationController.paginateByIndex(indexPath)
  }
  
  func cancelPrepareItemFor(_ indexPath: Int) {
    
  }
  
  func cleanUpData() {
    dropCurrentRelationsFor(contentType)
  }
  
  func initialFetchData() {
    
    do {
      try fetchResultController.performFetch()
    } catch {
      presenter.handleError(error)
    }
  }
  
  func initialRefresh() {
    switch contentType {
    case .followers(_):
      paginationController.initialRequest()
    case .following(let user):
      tagService.getFollowedTags(user, page: 0, perPage: 5) { [weak self] in
        switch $0 {
        case .success(let response):
          let followedTags = UsersListing.FollowedTagsModel(tags: response.0, totalCount: response.1.totalCount)
          self?.presenter.presentFollowedTags(followedTags)
          self?.paginationController.initialRequest()
        case .failure(let error):
          self?.presenter.handleError(error)
          self?.paginationController.initialRequest()
        }
      }
    case .friends(_), .editFriends(_), .mutedUsers(_):
      paginationController.initialRequest()
    }
  }
  
}

// MARK: - Interactor Viper Components Api
private extension UsersListingInteractor {
  var presenter: UsersListingPresenterApi {
    return _presenter as! UsersListingPresenterApi
  }
}

extension UsersListingInteractor {
  fileprivate func performFetchItemsAndSaveToStorage(page: Int, perPage: Int) {
    let completeHandler: ResultCompleteHandler<([PartialUserProtocol], PaginationInfoProtocol), PibbleError> = { [weak self] in
      switch $0 {
      case .success(let response):
        guard let strongSelf = self else {
          return
        }
        
        let relations: [PartialUserRelations]
        
        switch strongSelf.contentType {
        case .followers(let targetUser):
          relations = response.0.map { PartialUserRelations.following($0, follows: targetUser) }
        case .following(let targetUser):
          relations = response.0.map { PartialUserRelations.followed($0, by: targetUser) }
        case .friends(let targetUser), .editFriends(let targetUser):
          relations = response.0.map { PartialUserRelations.friend($0, of: targetUser) }
        case .mutedUsers(let targetUser):
          relations = response.0.map { PartialUserRelations.muted($0, by: targetUser) }
        }
        
        strongSelf.coreDataStorage.updateStorage(with: relations)
        strongSelf.paginationController.updatePaginationInfo(response.1)
      case .failure(let error):
        self?.presenter.handleError(error)
      }
    }
    
    switch contentType {
    case .followers(let targetUser):
      userInteractionService.getFollowersForUser(username: targetUser.userName, page: page, perPage: perPage, complete: completeHandler)
    case .following(let targetUser):
      userInteractionService.getFollowingsForUser(username: targetUser.userName, page: page, perPage: perPage, complete: completeHandler)
    case .friends(let targetUser), .editFriends(let targetUser):
      userInteractionService.getFriendsForUser(username: targetUser.userName, page: page, perPage: perPage, complete: completeHandler)
    case .mutedUsers(_):
      userInteractionService.getMutedUsers(page: page, perPage: perPage, complete: completeHandler)
    }
  }
  
  fileprivate func fetchPredicate() -> NSPredicate? {
    switch contentType {
    case .followers(let user):
      return NSPredicate(format: "ANY follows.id = \(user.identifier)")
    case .following(let user):
      return NSPredicate(format: "ANY followedBy.id = \(user.identifier)")
    case .friends(let user), .editFriends(let user):
      return NSPredicate(format: "ANY friends.id = \(user.identifier)")
    case .mutedUsers(let user):
      return NSPredicate(format: "ANY mutedByUsers.id = \(user.identifier)")
    }
  }
  
  fileprivate func sortDesriptors() -> [NSSortDescriptor] {
    return [NSSortDescriptor(key: #keyPath(UserManagedObject.name), ascending: true, selector: #selector(NSString.caseInsensitiveCompare))]
  }
}

//MARK:- FetchedResultsControllerDelegate

extension UsersListingInteractor: FetchedResultsControllerDelegate {
  func updateItems(_ proxy: FetchedResultsControllerDelegateProxy, updates: CollectionViewModelUpdate) {
    presenter.presentCollectionUpdates(updates)
  }
}

//MARK:- PaginationControllerDelegate

extension UsersListingInteractor: PaginationControllerDelegate {
  func request(page: Int, perPage: Int) {
    performFetchItemsAndSaveToStorage(page: page, perPage: perPage)
  }
}

//MARL:- Helpers

extension UsersListingInteractor {
  fileprivate func dropCurrentRelationsFor(_ filterType: UsersListing.ContentType) {
    //managed user is created in workerContext context to be saved correctly in update storage method
    //todo: move to storable relations
    
    switch filterType {
    case .followers(let user):
      let managedUser = UserManagedObject.replaceOrCreate(with: user, in: coreDataStorage.workerContext)
      coreDataStorage.workerContext.perform {
        managedUser.followedBy = NSSet()
      }
      coreDataStorage.updateStorage(with: [managedUser])
    case .following(let user):
      let managedUser = UserManagedObject.replaceOrCreate(with: user, in: coreDataStorage.workerContext)
      coreDataStorage.workerContext.perform {
        managedUser.follows = NSSet()
      }
      coreDataStorage.updateStorage(with: [managedUser])
    case .friends(let user), .editFriends(let user):
      let managedUser = UserManagedObject.replaceOrCreate(with: user, in: coreDataStorage.workerContext)
      coreDataStorage.workerContext.perform {
        managedUser.friends = NSSet()
      }
      coreDataStorage.updateStorage(with: [managedUser])
    case .mutedUsers(let user):
      let managedUser = UserManagedObject.replaceOrCreate(with: user, in: coreDataStorage.workerContext)
      coreDataStorage.workerContext.perform {
        managedUser.mutedUsers = NSSet()
      }
      coreDataStorage.updateStorage(with: [managedUser])
    }
  }
}
