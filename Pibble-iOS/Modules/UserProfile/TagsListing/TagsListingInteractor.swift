//
//  TagsListingInteractor.swift
//  Pibble-iOS
//
//  Created by Sergey Kazakov on 14/03/2019.
//Copyright © 2019 com.kazai. All rights reserved.
//

import CoreData

// MARK: - TagsListingInteractor Class
final class TagsListingInteractor: Interactor {
  fileprivate let coreDataStorage: CoreDataStorageServiceProtocol
  fileprivate var paginationController: PaginationControllerProtocol
  fileprivate var tagService: TagServiceProtocol
  
  let filterType: TagsListing.FilterType
  
  fileprivate lazy var fetchedResultsControllerDelegateProxy: FetchedResultsControllerDelegateProxy = {
    FetchedResultsControllerDelegateProxy(delegate: self)
  }()
  
  fileprivate lazy var fetchResultController: NSFetchedResultsController<TagManagedObject> = {
    let fetchRequest: NSFetchRequest<TagManagedObject> = TagManagedObject.fetchRequest()
    fetchRequest.predicate = fetchPredicate()
    fetchRequest.sortDescriptors = sortDesriptors()
    fetchRequest.fetchBatchSize = 30
    
    let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: coreDataStorage.viewContext, sectionNameKeyPath: nil, cacheName: nil)
    
    fetchedResultsController.delegate = fetchedResultsControllerDelegateProxy
    return fetchedResultsController
  }()
  
  init(coreDataStorage: CoreDataStorageServiceProtocol,
       tagService: TagServiceProtocol,
       filterType: TagsListing.FilterType) {
    self.coreDataStorage = coreDataStorage
    self.tagService = tagService
    self.filterType = filterType
    self.paginationController = PaginationController(itemsPerPage: 10, requestItems: 10, shouldRefreshTop: false, shouldRefreshInTheMiddle: false)
    
    super.init()
    self.paginationController.delegate = self
  }
}


// MARK: - TagsListingInteractor API
extension TagsListingInteractor: TagsListingInteractorApi {
  func refreshTag(_ tag: TagProtocol) {
    tagService.getRelatedPostsFor(tag, page: 0, perPage: 1) { [weak self] in
      guard let strongSelf = self else {
        return
      }
      
      switch $0 {
      case .success(let tag, _, _, _):
        strongSelf.coreDataStorage.batchUpdateStorage(with: [tag])
      case .failure(let error):
        strongSelf.presenter.handleError(error)
      }
    }
  }
  
  func performFollowingActionAt(_ indexPath: IndexPath) {
    let tag = fetchResultController.object(at: indexPath)
    
    
    let isFollowedByCurrentUser = tag.isFollowedByCurrentUser ?? false
    
    tag.isFollowed = !isFollowedByCurrentUser
    
    let complete: CompleteHandler = { [weak self] (err) in
      self?.refreshTag(tag)
      guard let error = err else {
        return
      }
      
      self?.presenter.handleErrorSilently(error)
    }
    
    isFollowedByCurrentUser ?
      tagService.unfollow(tag, complete: complete) :
      tagService.follow(tag, complete: complete)
  }
  
  func numberOfSections() -> Int {
    return fetchResultController.sections?.count ?? 0
  }
  
  func numberOfItemsInSection(_ section: Int) -> Int {
    return fetchResultController.sections?[section].numberOfObjects ?? 0
  }
  
  func itemAt(_ indexPath: IndexPath) -> TagProtocol {
    return fetchResultController.object(at: indexPath)
  }
  
  func prepareItemFor(_ indexPath: Int) {
    paginationController.paginateByIndex(indexPath)
  }
  
  func cancelPrepareItemFor(_ indexPath: Int) {
    
  }
  
  func initialFetchData() {
    dropCurrentRelationsFor(filterType)
    
    do {
      try fetchResultController.performFetch()
    } catch {
      presenter.handleError(error)
    }
  }
  
  func initialRefresh() {
    paginationController.initialRequest()
  }
}

// MARK: - Interactor Viper Components Api
private extension TagsListingInteractor {
  var presenter: TagsListingPresenterApi {
    return _presenter as! TagsListingPresenterApi
  }
}

extension TagsListingInteractor {
  fileprivate func performFetchItemsAndSaveToStorage(page: Int, perPage: Int) {
    let completeHandler: ResultCompleteHandler<([TagProtocol], PaginationInfoProtocol), PibbleError> = { [weak self] in
      switch $0 {
      case .success(let response):
        guard let strongSelf = self else {
          return
        }
        
        let relations: [TagsRelations]
        switch strongSelf.filterType {
        case .followedBy(let user):
          relations = response.0.map { TagsRelations.followedBy(tag: $0, user: user) }
        }

        strongSelf.coreDataStorage.updateTemporaryStorage(with: relations)
        strongSelf.paginationController.updatePaginationInfo(response.1)
      case .failure(let error):
        self?.presenter.handleError(error)
      }
    }
    
    switch filterType {
    case .followedBy(let user):
      tagService.getFollowedTags(user, page: page, perPage: perPage, complete: completeHandler)
    }
  }
  
  fileprivate func fetchPredicate() -> NSPredicate? {
    switch filterType {
    case .followedBy(let user):
      return NSPredicate(format: "ANY followedBy.id = \(user.identifier)")
    }
  }
  
  fileprivate func sortDesriptors() -> [NSSortDescriptor] {
    return [NSSortDescriptor(key: #keyPath(UserManagedObject.id), ascending: true)]
  }
}

//MARK:- FetchedResultsControllerDelegate

extension TagsListingInteractor: FetchedResultsControllerDelegate {
  func updateItems(_ proxy: FetchedResultsControllerDelegateProxy, updates: CollectionViewModelUpdate) {
    presenter.presentCollectionUpdates(updates)
  }
}

//MARK:- PaginationControllerDelegate

extension TagsListingInteractor: PaginationControllerDelegate {
  func request(page: Int, perPage: Int) {
    performFetchItemsAndSaveToStorage(page: page, perPage: perPage)
  }
}

//MARL:- Helpers

extension TagsListingInteractor {
  fileprivate func dropCurrentRelationsFor(_ filterType: TagsListing.FilterType) {
    switch filterType {
    case .followedBy(let user):
      let managedUser = UserManagedObject.replaceOrCreate(with: user, in: coreDataStorage.viewContext)
      if let allFollowedTags = managedUser.followedTags {
        managedUser.removeFromFollowedTags(allFollowedTags)
      }
    }
  }
}
