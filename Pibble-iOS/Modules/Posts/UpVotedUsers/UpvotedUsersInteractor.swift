//
//  UpvotedUsersInteractor.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 28.09.2018.
//Copyright © 2018 com.kazai. All rights reserved.
//

import Foundation
import CoreData

// MARK: - UpvotedUsersInteractor Class
final class UpvotedUsersInteractor: Interactor {
  fileprivate let coreDataStorage: CoreDataStorageServiceProtocol
  fileprivate let postingService: PostingServiceProtocol
  fileprivate let userInteractionsService: UserInteractionServiceProtocol
  fileprivate var paginationController: PaginationControllerProtocol
  fileprivate let contentType: UpvotedUsers.UpvotedContentType
  
  fileprivate var selectedItem: UpvoteManagedObject?
  
  fileprivate let inPlaceUpvoteAmount: Int = 10
  
  fileprivate lazy var fetchResultsController: NSFetchedResultsController<UpvoteManagedObject> = {
    return setupFRCFor(predicate: contentPredicate(),
                       sortDescriptors: sortDesriptors(),
                       delegate: fetchedResultsControllerDelegateProxy)
  }()
  
  fileprivate lazy var fetchedResultsControllerDelegateProxy: FetchedResultsControllerDelegateProxy = {
    FetchedResultsControllerDelegateProxy(delegate: self)
  }()
  
  init(coreDataStorage: CoreDataStorageServiceProtocol,
       postingService: PostingServiceProtocol,
       userInteractionsService: UserInteractionServiceProtocol,
       contentType: UpvotedUsers.UpvotedContentType) {
    self.coreDataStorage = coreDataStorage
    self.postingService = postingService
    self.userInteractionsService = userInteractionsService
    self.contentType = contentType
    
    self.paginationController = PaginationController(itemsPerPage: 10, requestItems: 10, shouldRefreshTop: false, shouldRefreshInTheMiddle: false)
    
    super.init()
    self.paginationController.delegate = self
  }
}

// MARK: - UpvotedUsersInteractor API
extension UpvotedUsersInteractor: UpvotedUsersInteractorApi {
  var unvotedContentType: UpvotedUsers.UpvotedContentType {
    return contentType
  }
  
  func selectItemAt(_ indexPath: IndexPath) {
    selectedItem = managedItemAt(indexPath)
  }
  
  func performInPlaceUpvoteForSelectedItem() {
    performUpvoteForSelectedItem(inPlaceUpvoteAmount)
  }
  
  
  func performUpvoteForSelectedItem(_ amount: Int) {
    guard let selectedItem = selectedItem,
      let user = selectedItem.upvotedUser
    else {
      return
    }
    
    let isCurrentUserUpvote = (user.isCurrent ?? false)
    
    guard !isCurrentUserUpvote else {
      return
    }
    
    selectedItem.upvoteBackAmount += Int32(amount)
    let storage = coreDataStorage
    storage.updateStorage(with: [selectedItem])
    userInteractionsService.upvote(user: user, amount: amount) { [weak self] in
      if let err = $0 {
        selectedItem.upvoteBackAmount -= Int32(amount)
        storage.updateStorage(with: [selectedItem])
        self?.presenter.handleError(err)
      }
    }
  }
  
  func performFollowingActionAt(_ indexPath: IndexPath) {
    let upvoteItem = managedItemAt(indexPath)
    
    guard let user = upvoteItem.fromUser else {
      return
    }
    
    let isCurrentUserUpvote = (user.isCurrent ?? false)
    
    guard !isCurrentUserUpvote else {
      return
    }
    
    let isFollowingNow = user.isFollowedByCurrentUser
    
    let storage = coreDataStorage
    let getUserWithCorrectState = { [weak self] in
      self?.userInteractionsService.getUser(username: user.userName) {
        switch $0 {
        case .success(let user):
          storage.updateStorage(with: [user])
        case .failure(let error):
          self?.presenter.handleError(error)
        }
      }
    }
    
    let completeBlock: CompleteHandler = { [weak self] in
      if let err = $0 {
        self?.presenter.handleError(err)
      }
      
      getUserWithCorrectState()
    }
    
    user.setFollowState(!isFollowingNow)
    upvoteItem.triggerRefresh()
    
    coreDataStorage.updateStorage(with: [upvoteItem])
    
    if isFollowingNow {
      userInteractionsService.unfollow(user: user, complete: completeBlock)
    } else {
      userInteractionsService.follow(user: user, complete: completeBlock)
    }
  }
  
  func numberOfSections() -> Int {
    return fetchResultsController.sections?.count ?? 0
  }
  
  func numberOfItemsInSection(_ section: Int) -> Int {
    return fetchResultsController.sections?[section].numberOfObjects ?? 0
  }
  
  func itemAt(_ indexPath: IndexPath) -> UpvoteProtocol {
    return fetchResultsController.object(at: indexPath)
  }
  
  func prepareItemFor(_ index: Int) {
    paginationController.paginateByIndex(index)
  }
  
  func cancelPrepareItemFor(_ index: Int) {
    
  }
  
  func initialFetchData() {
    performFetchFor()
  }
  
  func initialRefresh() {
    paginationController.initialRequest()
  }
}

// MARK: - Interactor Viper Components Api
private extension UpvotedUsersInteractor {
  var presenter: UpvotedUsersPresenterApi {
    return _presenter as! UpvotedUsersPresenterApi
  }
}

extension UpvotedUsersInteractor {
  fileprivate func managedItemAt(_ indexPath: IndexPath) -> UpvoteManagedObject {
    return fetchResultsController.object(at: indexPath)
  }
  
  fileprivate func performFetchFor() {
    do {
      try fetchResultsController.performFetch()
    } catch {
      presenter.handleError(error)
    }
    
    presenter.presentReload()
  }
  
  fileprivate func setupFRCFor(predicate: NSPredicate?, sortDescriptors: [NSSortDescriptor], delegate: FetchedResultsControllerDelegateProxy) -> NSFetchedResultsController<UpvoteManagedObject> {
    
    let fetchRequest: NSFetchRequest<UpvoteManagedObject> = UpvoteManagedObject.fetchRequest()
    fetchRequest.propertiesToFetch = ["fromUser"]
    fetchRequest.predicate = predicate
    fetchRequest.sortDescriptors = sortDescriptors
    fetchRequest.fetchBatchSize = 30
    
    let fetchResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: coreDataStorage.viewContext, sectionNameKeyPath: nil, cacheName: nil)
    
    fetchResultsController.delegate = delegate
    return fetchResultsController
  }
  
  fileprivate func performFetchAndSaveToStorage(page: Int, perPage: Int) {
    AppLogger.debug("performFetchUpvotesAndSaveToStorage \(page)")
    switch contentType {
    case .posting(let postingEntity):
      postingService.getUpvotesFor(postId: postingEntity.identifier, page: page, perPage: perPage) { [weak self] in
        switch $0 {
        case .success(let upvotes):
          guard let strongSelf = self else {
            return
          }
          
          let upvotesWithRelations = upvotes.0
            .map { return  UpvotesRelations.posting(upvote: $0, posting: postingEntity) }
          
          strongSelf.coreDataStorage.updateStorage(with: upvotesWithRelations)
          strongSelf.paginationController.updatePaginationInfo(upvotes.1)
        case .failure(let error):
          self?.presenter.handleError(error)
        }
      }
    }
  }
  
  fileprivate func contentPredicate() -> NSPredicate {
    switch contentType {
    case .posting(let postingEntity):
      return NSPredicate(format: "posting.id = \(postingEntity.identifier)")
    }
  }
  
  fileprivate func sortDesriptors() -> [NSSortDescriptor] {
    let sortDescriptor = NSSortDescriptor(key: #keyPath(UpvoteManagedObject.id), ascending: false)
    return [sortDescriptor]
  }
}

//MARK:- PaginationControllerDelegate

extension UpvotedUsersInteractor: PaginationControllerDelegate {
  func request(page: Int, perPage: Int) {
    performFetchAndSaveToStorage(page: page, perPage: perPage)
  }
}

//MARK:- FetchedResultsControllerDelegate

extension UpvotedUsersInteractor: FetchedResultsControllerDelegate {
  func updateItems(_ proxy: FetchedResultsControllerDelegateProxy, updates: CollectionViewModelUpdate) {
    presenter.presentCollectionUpdates(updates)
  }
}
