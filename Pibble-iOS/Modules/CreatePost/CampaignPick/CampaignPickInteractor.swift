//
//  CampaignPickInteractor.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 29.10.2018.
//Copyright © 2018 com.kazai. All rights reserved.
//

import Foundation
import CoreData

// MARK: - CampaignPickInteractor Class
final class CampaignPickInteractor: Interactor {
  let postingDraft: MutablePostDraftProtocol
  
  fileprivate let coreDataStorage: CoreDataStorageServiceProtocol
  fileprivate let postingService: PostingServiceProtocol
  fileprivate let campaignType: CampaignType
  
  fileprivate let createPostService: CreatePostServiceProtocol
  
  fileprivate var paginationController: PaginationControllerProtocol
  fileprivate(set) var selectedItem: FundingCampaignTeamManagedObject?
  
  fileprivate var performSearchObject = DelayBlockObject()
  
  fileprivate var searchString: String? {
    didSet {
      performSearchObject.cancel()
      performSearchObject.scheduleAfter(delay: 0.45) { [weak self] in
        self?.initialRefresh()
      }
    }
  }
  
  fileprivate lazy var fetchedResultsControllerDelegateProxy: FetchedResultsControllerDelegateProxy = {
    FetchedResultsControllerDelegateProxy(delegate: self)
  }()
  
  fileprivate lazy var fetchResultController: NSFetchedResultsController<FundingCampaignTeamManagedObject> = {
    let fetchRequest: NSFetchRequest<FundingCampaignTeamManagedObject> = FundingCampaignTeamManagedObject.fetchRequest()
    fetchRequest.predicate = fetchPredicate()
    fetchRequest.sortDescriptors = sortDesriptors()
    fetchRequest.fetchBatchSize = 30
    
    let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: coreDataStorage.viewContext, sectionNameKeyPath: nil, cacheName: nil)
    
    fetchedResultsController.delegate = fetchedResultsControllerDelegateProxy
    return fetchedResultsController
  }()
  
  init(coreDataStorage: CoreDataStorageServiceProtocol,
       postingService: PostingServiceProtocol,
       createPostService: CreatePostServiceProtocol,
       campaignType: CampaignType,
       postingDraft: MutablePostDraftProtocol) {
    self.coreDataStorage = coreDataStorage
    self.postingService = postingService
    self.createPostService = createPostService
    
    self.campaignType = campaignType
    self.postingDraft = postingDraft
    
    self.paginationController = PaginationController(itemsPerPage: 10, requestItems: 10, shouldRefreshTop: false, shouldRefreshInTheMiddle: false)
    
    super.init()
    self.paginationController.delegate = self
  }
}

// MARK: - CampaignPickInteractor API
extension CampaignPickInteractor: CampaignPickInteractorApi {
  var canBePosted: Bool {
    return postingDraft.canBePosted && selectedItem != nil
  }
  
  func deselectItem() {
    guard let selected = selectedItem else {
      return
    }
    
    guard let selectedIndexPath = fetchResultController.indexPath(forObject: selected) else {
      return
    }
    
    changeSelectedStateForItemAt(selectedIndexPath)
  }
  
  func updateSearchString(_ searchString: String) {
    guard searchString.count > 0 else {
      self.searchString = nil
      return
    }
    
    self.searchString = searchString
  }
  
  var selectedCampaignItem: FundingCampaignTeamProtocol? {
    return selectedItem
  }
  
  func isSelectedItemAt(_ indexPath: IndexPath) -> Bool {
    guard let selected = selectedItem else {
      return false
    }
    
    let selectedIndexPath = fetchResultController.indexPath(forObject: selected)
    return selectedIndexPath == indexPath
  }
  
  func changeSelectedStateForItemAt(_ indexPath: IndexPath) {
    guard let selected = selectedItem else {
      selectedItem = fetchResultController.object(at: indexPath)
      presenter.presentCollectionUpdates(CollectionViewModelUpdate.beginUpdates)
      presenter.presentCollectionUpdates(CollectionViewModelUpdate.update(idx: [indexPath]))
      presenter.presentCollectionUpdates(CollectionViewModelUpdate.endUpdates)
      return
    }
    
    let itemToSelect = itemAt(indexPath)
    
    guard itemToSelect.identifier != selected.identifier else {
      selectedItem = nil
      presenter.presentCollectionUpdates(CollectionViewModelUpdate.beginUpdates)
      presenter.presentCollectionUpdates(CollectionViewModelUpdate.update(idx: [indexPath]))
      presenter.presentCollectionUpdates(CollectionViewModelUpdate.endUpdates)
      return
    }
    
    presenter.presentCollectionUpdates(CollectionViewModelUpdate.beginUpdates)
    guard let oldIndexPath = fetchResultController.indexPath(forObject: selected) else {
      selectedItem = fetchResultController.object(at: indexPath)
      presenter.presentCollectionUpdates(CollectionViewModelUpdate.update(idx: [indexPath]))
      presenter.presentCollectionUpdates(CollectionViewModelUpdate.endUpdates)
      return
    }
    
    selectedItem = fetchResultController.object(at: indexPath)
    presenter.presentCollectionUpdates(CollectionViewModelUpdate.update(idx: [oldIndexPath, indexPath]))
    presenter.presentCollectionUpdates(CollectionViewModelUpdate.endUpdates)
  }
  
  func numberOfSections() -> Int {
    return fetchResultController.sections?.count ?? 0
  }
  
  func numberOfItemsInSection(_ section: Int) -> Int {
    return fetchResultController.sections?[section].numberOfObjects ?? 0
  }
  
  func itemAt(_ indexPath: IndexPath) -> FundingCampaignTeamProtocol {
    return fetchResultController.object(at: indexPath)
  }
  
  func prepareItemFor(_ indexPath: Int) {
    paginationController.paginateByIndex(indexPath)
  }
  
  func cancelPrepareItemFor(_ indexPath: Int) {
    
  }
  
  func initialFetchData() {
    do {
      try fetchResultController.performFetch()
    } catch {
      presenter.handleError(error)
    }
  }
  
  func initialRefresh() {
    paginationController.initialRequest()
  }
  
  func performPosting() {
    postingDraft.joinExistingCampaignTeam = selectedItem
    
    guard postingDraft.canBePosted else {
      return
    }
    
    createPostService.performPosting(draft: postingDraft)
  }
}

// MARK: - Interactor Viper Components Api
private extension CampaignPickInteractor {
  var presenter: CampaignPickPresenterApi {
    return _presenter as! CampaignPickPresenterApi
  }
}


extension CampaignPickInteractor {
  fileprivate func performFetchItemsAndSaveToStorage(page: Int, perPage: Int) {
    AppLogger.debug("performFetchCommentsAndSaveToStorage \(page)")
    let isInitialFetch = page == 0
    
    postingService.getFundingTeams(name: searchString, page: page, perPage: perPage, campaignType: campaignType) { [weak self] in
      switch $0 {
      case .success(let teams):
        guard let strongSelf = self else {
          return
        }
        if isInitialFetch {
          strongSelf.performCacheInvalidationRequest(skip: teams.0.map { $0.identifier })
        }
        
        strongSelf.coreDataStorage.updateStorage(with: teams.0.map { FundingCampaignTeamRelations.searchResult($0) })
        strongSelf.paginationController.updatePaginationInfo(teams.1)
      case .failure(let error):
        self?.presenter.handleError(error)
      }
    }
  }
  
  fileprivate func fetchPredicate() -> NSPredicate {
    let searchResultPredicate = basePredicate()
    let fundingTypePredicate = NSPredicate(format: "fundingType = %@", campaignType.rawValue)
  
    return NSCompoundPredicate(andPredicateWithSubpredicates: [searchResultPredicate, fundingTypePredicate])
  }
  
  fileprivate func basePredicate() -> NSPredicate {
    let searchResultPredicate = NSPredicate(format: "isSearchResult == %@", NSNumber(value: true))
    return searchResultPredicate
  }
  
  fileprivate func sortDesriptors() -> [NSSortDescriptor] {
    return [NSSortDescriptor(key: #keyPath(FundingCampaignTeamManagedObject.id), ascending: false)]
  }
  
  fileprivate func propertiesToUpdateForCacheInvalidation() -> [String: Any]? {
    return  ["isSearchResult": NSNumber(value: false)]
  }
  
  fileprivate func performCacheInvalidationRequest(skip postIds: [Int]) {
    AppLogger.debug("performOldObjectsCacheInvalidationRequest")
    guard let propertiesToUpdate = propertiesToUpdateForCacheInvalidation() else {
      return
    }
    
    let predicate: NSPredicate = basePredicate()
    
    guard postIds.count > 0 else {
      coreDataStorage.batchUpdateObjects(FundingCampaignTeamManagedObject.self, predicate: predicate, propertiesToUpdate: propertiesToUpdate)
      return
    }
    
    let skipObjectsPredicate =  NSPredicate(format: "NOT (id IN %@)", postIds )
    let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [skipObjectsPredicate, predicate])
    coreDataStorage.batchUpdateObjects(FundingCampaignTeamManagedObject.self,
                                       predicate: compoundPredicate,
                                       propertiesToUpdate: propertiesToUpdate)
    
  }
}

//MARK:- FetchedResultsControllerDelegate

extension CampaignPickInteractor: FetchedResultsControllerDelegate {
  func updateItems(_ proxy: FetchedResultsControllerDelegateProxy, updates: CollectionViewModelUpdate) {
    presenter.presentCollectionUpdates(updates)
  }
}

//MARK:- PaginationControllerDelegate

extension CampaignPickInteractor: PaginationControllerDelegate {
  func request(page: Int, perPage: Int) {
    performFetchItemsAndSaveToStorage(page: page, perPage: perPage)
  }
}
