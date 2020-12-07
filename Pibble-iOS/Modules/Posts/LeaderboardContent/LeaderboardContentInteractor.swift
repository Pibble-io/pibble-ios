//
//  LeaderboardContentInteractor.swift
//  Pibble-iOS
//
//  Created by Sergey Kazakov on 11/04/2019.
//Copyright © 2019 com.kazai. All rights reserved.
//

import CoreData

// MARK: - LeaderboardContentInteractor Class
final class LeaderboardContentInteractor: Interactor {
  fileprivate let coreDataStorage: CoreDataStorageServiceProtocol
  fileprivate let topGroupsService: TopGroupPostsServiceProtocol
  
  fileprivate var paginationController: PaginationControllerProtocol
  
  fileprivate let leaderboardType: LeaderboardType
  
  fileprivate lazy var fetchedResultsControllerDelegateProxy: FetchedResultsControllerDelegateProxy = {
    FetchedResultsControllerDelegateProxy(delegate: self)
  }()
  
  fileprivate lazy var topItemsfetchedResultsControllerDelegateProxy: FetchedResultsControllerDelegateProxy = {
    FetchedResultsControllerDelegateProxy(delegate: self)
  }()
  
  fileprivate var fetchResultController: NSFetchedResultsController<LeaderboardEntryManagedObject>? = nil
  
  fileprivate var topItemsfetchResultController: NSFetchedResultsController<LeaderboardEntryManagedObject>? = nil
  
  
  init(coreDataStorage: CoreDataStorageServiceProtocol,
       topGroupsService: TopGroupPostsServiceProtocol,
       leaderboardType: LeaderboardType) {
    self.coreDataStorage = coreDataStorage
    self.topGroupsService = topGroupsService
    self.leaderboardType = leaderboardType
    
    self.paginationController = PaginationController(itemsPerPage: 10, requestItems: 10, shouldRefreshTop: false, shouldRefreshInTheMiddle: true)
    
    super.init()
    self.paginationController.delegate = self
  }
  
  fileprivate var topItemsCount: Int {
    return 3
  }
}

// MARK: - LeaderboardContentInteractor API
extension LeaderboardContentInteractor: LeaderboardContentInteractorApi {
  func topItemAt(_ indexPath: IndexPath) -> LeaderboardEntryProtocol? {
    return topItemIfExistAt(indexPath)
  }
  
  var listStartItemPlaceIndex: Int {
    return topItemsCount + 1
  }
 
  
  func numberOfSections() -> Int {
    return fetchResultController?.sections?.count ?? 0
  }
  
  func numberOfItemsInSection(_ section: Int) -> Int {
    return fetchResultController?.sections?[section].numberOfObjects ?? 0
  }
  
  func itemAt(_ indexPath: IndexPath) -> LeaderboardEntryProtocol? {
    return itemIfExistAt(indexPath)
  }
  
  func prepareItemFor(_ indexPath: IndexPath) {
    paginationController.paginateByIndex(indexPath.item + topItemsCount)
  }
  
  func cancelPrepareItemFor(_ indexPath: Int) {
    
  }
  
  func initialRefresh() {
    paginationController.initialRequest()
  }
  
  func initialFetchData() {
    performFetchFor()
  }
}

// MARK: - Interactor Viper Components Api
private extension LeaderboardContentInteractor {
  var presenter: LeaderboardContentPresenterApi {
    return _presenter as! LeaderboardContentPresenterApi
  }
}

// MARK: - Helpers
extension LeaderboardContentInteractor {
  fileprivate func itemIfExistAt(_ indexPath: IndexPath) -> LeaderboardEntryManagedObject? {
    guard indexPath.section >= 0 else {
      return nil
    }
    
    guard indexPath.section < fetchResultController?.sections?.count ?? 0,
      indexPath.item < fetchResultController?.sections?[indexPath.section].numberOfObjects ?? 0 else {
        return nil
    }
    
    return fetchResultController?.object(at: indexPath)
  }
  
  fileprivate func topItemIfExistAt(_ indexPath: IndexPath) -> LeaderboardEntryManagedObject? {
    guard indexPath.section >= 0 else {
      return nil
    }
    
    guard indexPath.section < topItemsfetchResultController?.sections?.count ?? 0,
      indexPath.item < topItemsfetchResultController?.sections?[indexPath.section].numberOfObjects ?? 0 else {
        return nil
    }
    
    return topItemsfetchResultController?.object(at: indexPath)
  }

  fileprivate func performFetchFor() {
    topItemsfetchResultController = setupFRCFor(predicate: topItemsfetchPredicateFor(),
                                               sortDescriptors: sortDesriptors(),
                                               delegate: topItemsfetchedResultsControllerDelegateProxy)
    
    fetchResultController = setupFRCFor(predicate: fetchPredicateFor(),
                                        sortDescriptors: sortDesriptors(),
                                        delegate: fetchedResultsControllerDelegateProxy)
    
    do {
      try fetchResultController?.performFetch()
    } catch {
      presenter.handleError(error)
    }
    
    do {
      try topItemsfetchResultController?.performFetch()
    } catch {
      presenter.handleError(error)
    }
    
    presenter.presentReload()
  }
  
  fileprivate func presentTopItems() {
    guard let objects = topItemsfetchResultController?.fetchedObjects
      else {
        return
    }
    
    presenter.presentTopItems(Array(objects.prefix(topItemsCount)))
  }
  
  fileprivate func setupFRCFor(predicate: NSPredicate?, sortDescriptors: [NSSortDescriptor], delegate: FetchedResultsControllerDelegateProxy) -> NSFetchedResultsController<LeaderboardEntryManagedObject> {
    
    let fetchRequest: NSFetchRequest<LeaderboardEntryManagedObject> = LeaderboardEntryManagedObject.fetchRequest()
    fetchRequest.predicate = predicate
    fetchRequest.sortDescriptors = sortDescriptors
    fetchRequest.fetchBatchSize = 30
    
    let fetchResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: coreDataStorage.viewContext, sectionNameKeyPath: nil, cacheName: nil)
    
    fetchResultsController.delegate = delegate
    return fetchResultsController
  }
  
  fileprivate func performFetchItemsAndSaveToStorage(page: Int, perPage: Int) {
    let isInitialFetch = page == 0
    
    AppLogger.debug("performFetchItemsAndSaveToStorage \(page), perPage: \(perPage)")
    
    topGroupsService.getLeaderboard(leaderboardType, page: page, perPage: perPage) { [weak self] in
      guard let strongSelf = self else {
        return
      }
      
      switch $0 {
      case .success(let items, let pagination):
        guard isInitialFetch else {
          let listingItems = items
          
          let pageIndex = page * perPage
          
          let listingItemsRelation = listingItems
            .enumerated()
            .map { LeaderboardRelations.top($0.element, isTop: false, sortId: pageIndex + $0.offset) }
          
          strongSelf.coreDataStorage.updateStorage(with: listingItemsRelation)
          strongSelf.paginationController.updatePaginationInfo(pagination)
          return
        }
        
        let topItems = items.prefix(strongSelf.topItemsCount)
        let listingItems = items.dropFirst(strongSelf.topItemsCount)
        
        let pageIndex = page * perPage
        let responseTopItemsCount = topItems.count
        
        let topItemsRelations = topItems
          .enumerated()
          .map { LeaderboardRelations.top($0.element,
                                          isTop: true,
                                          sortId: pageIndex + $0.offset) }
        let listingItemsRelations = listingItems
          .enumerated()
          .map { LeaderboardRelations.top($0.element,
                                          isTop: false,
                                          sortId: pageIndex + $0.offset + responseTopItemsCount) }
        
        strongSelf.performCacheInvalidationRequest(for: strongSelf.leaderboardType, skip: listingItems.map { $0.identifier })
        strongSelf.coreDataStorage.updateStorage(with: topItemsRelations)
        strongSelf.coreDataStorage.updateStorage(with: listingItemsRelations)
        
        strongSelf.paginationController.updatePaginationInfo(pagination)
      case .failure(let error):
        self?.presenter.handleError(error)
      }
    }
  }
  
  fileprivate func fetchPredicateFor() -> NSPredicate? {
    let basePredicate =  baseFetchPredicateFor(leaderboardType)
    let notTopPredicate = NSPredicate(format: "isTop == %@", NSNumber(value: false))
    return NSCompoundPredicate(andPredicateWithSubpredicates: [basePredicate, notTopPredicate])
  }
  
  fileprivate func baseFetchPredicateFor(_ leaderboardType: LeaderboardType) -> NSPredicate {
    switch leaderboardType {
    case .days(let numberOfDays):
      return NSPredicate(format: "dailyChallenge == \(numberOfDays)")
    case .allHistory:
      return NSPredicate(format: "allHistoryChallenge == %@", NSNumber(value: true))
    }
  }
  
  fileprivate func topItemsfetchPredicateFor() -> NSPredicate? {
    let basePredicate =  baseFetchPredicateFor(leaderboardType)
    let topPredicate = NSPredicate(format: "isTop == %@", NSNumber(value: true))
    return NSCompoundPredicate(andPredicateWithSubpredicates: [basePredicate, topPredicate])
  }
  
  fileprivate func sortDesriptors() -> [NSSortDescriptor] {
    return [NSSortDescriptor(key: #keyPath(LeaderboardEntryManagedObject.value), ascending: false),
            NSSortDescriptor(key: #keyPath(LeaderboardEntryManagedObject.sortId), ascending: true)
    ]
  }
  
  fileprivate func propertiesToUpdateForCacheInvalidation(for leaderboardType: LeaderboardType) -> [String: Any]? {
    switch leaderboardType {
    case .days(_):
      return ["dailyChallenge": NSNumber(value: -1)]
    case .allHistory:
      return ["allHistoryChallenge": NSNumber(value: false)]
    }
  }
  
  fileprivate func performCacheInvalidationRequest(for leaderboardType: LeaderboardType, skip postIds: [String]) {
    AppLogger.debug("performOldObjectsCacheInvalidationRequest")
    guard let propertiesToUpdate = propertiesToUpdateForCacheInvalidation(for: leaderboardType) else {
      return
    }
    
    let predicate: NSPredicate = baseFetchPredicateFor(leaderboardType)
    
    guard postIds.count > 0 else {
      coreDataStorage.batchUpdateObjects(LeaderboardEntryManagedObject.self, predicate: predicate, propertiesToUpdate: propertiesToUpdate)
      return
    }
    
    let skipObjectsPredicate =  NSPredicate(format: "NOT (id IN %@)", postIds )
    let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [skipObjectsPredicate, predicate])
    coreDataStorage.batchUpdateObjects(LeaderboardEntryManagedObject.self,
                                       predicate: compoundPredicate,
                                       propertiesToUpdate: propertiesToUpdate)
    
   }
}


//MARK:- FetchedResultsControllerDelegate

extension LeaderboardContentInteractor: FetchedResultsControllerDelegate {
  
  
  func updateItems(_ proxy: FetchedResultsControllerDelegateProxy, updates: CollectionViewModelUpdate) {
    guard proxy == fetchedResultsControllerDelegateProxy else {
      
      guard case CollectionViewModelUpdate.endUpdates = updates else {
        return
      }
      
      presentTopItems()
      return
    }
    
    presenter.presentCollectionUpdates(updates)
  }
}


//MARK:- PaginationControllerDelegate

extension LeaderboardContentInteractor: PaginationControllerDelegate {
  func request(page: Int, perPage: Int) {
    performFetchItemsAndSaveToStorage(page: page, perPage: perPage)
  }
  
  func request(cursorId: Int, perPage: Int) {
    
  }
  
  func requestInitial(perPage: Int) {
    performFetchItemsAndSaveToStorage(page: 0, perPage: perPage)
  }
}
