//
//  DiscoverSearchContentSearchHistoryInteractor.swift
//  Pibble
//
//  Created by Kazakov Sergey on 30.12.2018.
//  Copyright © 2018 com.kazai. All rights reserved.
//

import Foundation
import CoreData

class DiscoverSearchContentSearchHistoryInteractor: Interactor {
  fileprivate let coreDataStorage: CoreDataStorageServiceProtocol

  fileprivate lazy var fetchedResultsControllerDelegateProxy: FetchedResultsControllerDelegateProxy = {
    FetchedResultsControllerDelegateProxy(delegate: self)
  }()
  
  fileprivate lazy var fetchResultController: NSFetchedResultsController<BaseSearchResultManagedObject> = {
    let fetchRequest: NSFetchRequest<BaseSearchResultManagedObject> = BaseSearchResultManagedObject.fetchRequest()
    fetchRequest.predicate = fetchPredicate()
    fetchRequest.sortDescriptors = sortDesriptors()
    fetchRequest.fetchLimit = 25
    let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: coreDataStorage.viewContext, sectionNameKeyPath: nil, cacheName: nil)
    
    fetchedResultsController.delegate = fetchedResultsControllerDelegateProxy
    return fetchedResultsController
  }()
  
  init(coreDataStorage: CoreDataStorageServiceProtocol) {
    self.coreDataStorage = coreDataStorage
    super.init()
  }
}

// MARK: - Interactor Viper Components Api
private extension DiscoverSearchContentSearchHistoryInteractor {
  var presenter: DiscoverSearchContentPresenterApi {
    return _presenter as! DiscoverSearchContentPresenterApi
  }
}

// MARK: - DiscoverSearchContentInteractor API
extension DiscoverSearchContentSearchHistoryInteractor: DiscoverSearchContentInteractorApi {
  var isCopySearchStringAvailable: Bool {
    return true
  }
  
  func saveToSearchHistoryItemAt(_ indexPath: IndexPath) { }
  
  func performSearch(_ text: String) {  }
  
  func numberOfSections() -> Int {
    return fetchResultController.sections?.count ?? 0
  }
  
  func numberOfItemsInSection(_ section: Int) -> Int {
    return fetchResultController.sections?[section].numberOfObjects ?? 0
  }
  
  func itemAt(_ indexPath: IndexPath) -> SearchResultEntity {
    return fetchResultController.object(at: indexPath).searchResultEntity
  }
  
  func prepareItemFor(_ index: Int) {
    
  }
  
  func cancelPrepareItemFor(_ index: Int) {
    
  }
  
  func initialFetchData() {
    do {
      try fetchResultController.performFetch()
    } catch {
      presenter.handleError(error)
    }
  }
  
  func initialRefresh() {
    
  }
}

extension DiscoverSearchContentSearchHistoryInteractor {
  fileprivate func fetchPredicate() -> NSPredicate? {
    return nil
  }
  
  fileprivate func sortDesriptors() -> [NSSortDescriptor] {
    return [NSSortDescriptor(key: #keyPath(BaseSearchResultManagedObject.resultType), ascending: true),
            NSSortDescriptor(key: #keyPath(BaseSearchResultManagedObject.createdAt), ascending: false)]
  }
}

//MARK:- FetchedResultsControllerDelegate

extension DiscoverSearchContentSearchHistoryInteractor: FetchedResultsControllerDelegate {
  func updateItems(_ proxy: FetchedResultsControllerDelegateProxy, updates: CollectionViewModelUpdate) {
    presenter.presentCollectionUpdates(updates)
  }
}

