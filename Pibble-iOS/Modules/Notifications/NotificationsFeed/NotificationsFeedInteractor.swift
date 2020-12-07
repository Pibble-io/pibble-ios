//
//  NotificationsFeedInteractor.swift
//  Pibble-iOS
//
//  Created by Sergey Kazakov on 26/06/2019.
//Copyright © 2019 com.kazai. All rights reserved.
//

import CoreData


// MARK: - NotificationsFeedInteractor Class
final class NotificationsFeedInteractor: Interactor {
  fileprivate let coreDataStorage: CoreDataStorageServiceProtocol
  fileprivate var paginationController: PaginationControllerProtocol
  fileprivate let accountProfileService: AccountProfileServiceProtocol
  fileprivate let notificationsFeedService: NotificationsFeedServiceProtocol
  fileprivate let userInteractionsService: UserInteractionServiceProtocol
  
  fileprivate lazy var fetchedResultsControllerDelegateProxy: FetchedResultsControllerDelegateProxy = {
    FetchedResultsControllerDelegateProxy(delegate: self)
  }()
  
  fileprivate var fetchResultsController: NSFetchedResultsController<NotificationManagedObject>? = nil
  
  
  init(coreDataStorage: CoreDataStorageServiceProtocol,
       notificationsFeedService: NotificationsFeedServiceProtocol,
       userInteractionsService: UserInteractionServiceProtocol,
       accountProfileService: AccountProfileServiceProtocol
       ) {
    self.coreDataStorage = coreDataStorage
    self.notificationsFeedService = notificationsFeedService
    self.userInteractionsService = userInteractionsService
    self.accountProfileService = accountProfileService
    
    self.paginationController = CursorPaginationController(requestItems: 10, shouldRefreshInTheMiddle: false)
    super.init()
    self.paginationController.delegate = self
  }
}

// MARK: - NotificationsFeedInteractor API
extension NotificationsFeedInteractor: NotificationsFeedInteractorApi {
  func initialFetchData() {
    if let profile = accountProfileService.currentUserAccount {
      performFetchFor(account: profile)
    } else {
      accountProfileService.getProfile { [weak self] in
        switch $0 {
        case .success(let profile):
          self?.performFetchFor(account: profile)
        case .failure(let err):
          self?.presenter.handleError(err)
        }
      }
    }
  }
  
  func initialRefresh() {
    paginationController.initialRequest()
  }
  
  func prepareItemFor(_ indexPath: IndexPath) {
    guard let item = itemIfExistAt(indexPath) else {
      return
    }
    
    let cursor = Cursor(id: item.identifier, sortIds: [item.identifier])
    paginationController.paginateByIdentifier(cursor)
  }
  
  func cancelPrepareItemFor(_ indexPath: IndexPath) {
    
  }
  
  func sectonNameAt(section: Int) -> String? {
    return fetchResultsController?.sections?[section].name
  }
  
  func numberOfSections() -> Int {
    return fetchResultsController?.sections?.count ?? 0
  }
  
  func numberOfItemsInSection(_ section: Int) -> Int {
    return fetchResultsController?.sections?[section].numberOfObjects ?? 0
  }
  
  func itemAt(_ indexPath: IndexPath) -> NotificationEntity? {
    return itemIfExistAt(indexPath)?.notificationEntity
  }
  
  func performFollowUserActionAt(_ indexPath: IndexPath) {
    guard let notificationItem = itemIfExistAt(indexPath) else {
      return
    }
    
    guard let user = notificationItem.fromUser  else {
      return
    }
    
    guard !(user.isCurrent ?? false) else {
      return
    }
    
    let isFollowedByCurrentUser = user.isFollowedByMe
    let followersChange: Int32 = isFollowedByCurrentUser ? -1 : 1
    
    guard !isFollowedByCurrentUser else {
      return
    }
    
    user.isFollowedByMe = !isFollowedByCurrentUser
    user.followersCount += followersChange
    notificationItem.triggerRefresh()
    
    user.outcomingNotifications?.forEach {
      if let notification = ($0 as? NotificationManagedObject),
        !notification.isFault {
        notification.triggerRefresh()
      }
    }
    
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
      userInteractionsService.unfollow(user: user, complete: complete) :
      userInteractionsService.follow(user: user, complete: complete)
  }
  
  
}

// MARK: - Interactor Viper Components Api
private extension NotificationsFeedInteractor {
  var presenter: NotificationsFeedPresenterApi {
    return _presenter as! NotificationsFeedPresenterApi
  }
}

//MARK:- Helpers

extension NotificationsFeedInteractor {
  fileprivate func itemIfExistAt(_ indexPath: IndexPath) -> NotificationManagedObject? {
    guard indexPath.section >= 0 else {
      return nil
    }
    
    guard indexPath.section < fetchResultsController?.sections?.count ?? 0,
      indexPath.item < fetchResultsController?.sections?[indexPath.section].numberOfObjects ?? 0 else {
        return nil
    }

    return fetchResultsController?.object(at: indexPath)
  }
  
  fileprivate func performFetchFor(account: UserProtocol) {
    fetchResultsController = setupFRCFor(predicate: notificationsFeedPredicateFor(account),
                                         sortDescriptors: sortDesriptors(),
                                         delegate: fetchedResultsControllerDelegateProxy)
    
    do {
      try fetchResultsController?.performFetch()
    } catch {
      presenter.handleError(error)
    }
    
    presenter.presentReload()
  }
  
  fileprivate func setupFRCFor(predicate: NSPredicate?, sortDescriptors: [NSSortDescriptor], delegate: FetchedResultsControllerDelegateProxy) -> NSFetchedResultsController<NotificationManagedObject> {
    
    let fetchRequest: NSFetchRequest<NotificationManagedObject> = NotificationManagedObject.fetchRequest()
    fetchRequest.predicate = predicate
    fetchRequest.sortDescriptors = sortDescriptors
    fetchRequest.fetchBatchSize = 30
    
    let fetchResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: coreDataStorage.viewContext, sectionNameKeyPath: #keyPath(NotificationManagedObject.createdAtDateComponent), cacheName: nil)
    
    fetchResultsController.delegate = delegate
    return fetchResultsController
  }
  
  fileprivate func performFetchItemsAndSaveToStorageFor(user: UserProtocol, cursorId: Int?, perPage: Int) {
    notificationsFeedService.getNotificationsFeed(cursorId: cursorId, perPage: perPage) { [weak self] in
      guard let strongSelf = self else {
        return
      }
      switch $0 {
      case .success(let notifications, let paginationInfo):
        let cursors = notifications
          .map { Cursor(id: $0.baseNotification.identifier, sortIds: [$0.baseNotification.identifier]) }
        let userNotificationsRelations = notifications
          .map { return PartialNotificationsRelations.userNotificationsFeed(user, notification: $0) }
        
        strongSelf.coreDataStorage.updateTemporaryStorage(with: userNotificationsRelations)
        strongSelf.paginationController.updatePaginationInfo(cursors, paginationInfo: paginationInfo)
      case .failure(let error):
        strongSelf.presenter.handleError(error)
      }
    }
  }
  
  fileprivate func performFetchAndSaveToStorage(cursorId: Int?, perPage: Int) {
    AppLogger.debug("performFetchAndSaveToStorage \(String(describing: cursorId))")
    
    if let user = accountProfileService.currentUserAccount {
      performFetchItemsAndSaveToStorageFor(user: user, cursorId: cursorId, perPage: perPage)
    } else {
      accountProfileService.getProfile { [weak self] in
        switch $0 {
        case .success(let user):
          self?.performFetchItemsAndSaveToStorageFor(user: user, cursorId: cursorId, perPage: perPage)
        case .failure(let err):
          self?.presenter.handleError(err)
        }
      }
    }
  }
  
  fileprivate func notificationsFeedPredicateFor(_ user: UserProtocol) -> NSPredicate {
    return NSPredicate(format: "feedUser.id == \(user.identifier)")
  }
  
  fileprivate func sortDesriptors() -> [NSSortDescriptor] {
    let dateSortDescriptor = NSSortDescriptor(key: #keyPath(NotificationManagedObject.createdAtDateComponent), ascending: false)
    
    let idSortDescriptor = NSSortDescriptor(key: #keyPath(NotificationManagedObject.id), ascending: false)
    return [dateSortDescriptor, idSortDescriptor]
  }
}

//MARK:- PaginationControllerDelegate

extension NotificationsFeedInteractor: PaginationControllerDelegate {
  func request(page: Int, perPage: Int) {
    
  }
  
  func request(cursorId: Int, perPage: Int) {
    performFetchAndSaveToStorage(cursorId: cursorId, perPage: perPage)
  }
  
  func requestInitial(perPage: Int) {
    performFetchAndSaveToStorage(cursorId: nil, perPage: perPage)
  }
}

//MARK:- FetchedResultsControllerDelegate

extension NotificationsFeedInteractor: FetchedResultsControllerDelegate {
  func updateItems(_ proxy: FetchedResultsControllerDelegateProxy, updates: CollectionViewModelUpdate) {
    presenter.presentCollectionUpdates(updates)
  }
}
