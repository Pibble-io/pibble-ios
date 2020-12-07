//
//  SearchResultTagDetailContentInteractor.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 28.12.2018.
//Copyright © 2018 com.kazai. All rights reserved.
//

import Foundation
import CoreData

// MARK: - SearchResultTagDetailContentInteractor Class
final class SearchResultTagDetailContentInteractor: Interactor {
  fileprivate let tagService: TagServiceProtocol
  fileprivate let coreDataStorage: CoreDataStorageServiceProtocol
  
  var observableTag: ObservableManagedObject<TagManagedObject>
  let tagForPresentation: TagProtocol
  
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
  
  init(tagService: TagServiceProtocol, coreDataStorage: CoreDataStorageServiceProtocol, tag: TagProtocol) {
    self.tagService = tagService
    self.coreDataStorage = coreDataStorage
    tagForPresentation = tag
    observableTag = TagManagedObject.createObservable(with: tag, in: coreDataStorage.viewContext)
  }
}

// MARK: - SearchResultTagDetailContentInteractor API
extension SearchResultTagDetailContentInteractor: SearchResultTagDetailContentInteractorApi {
  func performFollowAction() {
    guard let tag = observableTag.object else {
      return
    }
    
    let isCurrentlyFollowed = tag.isFollowedByCurrentUser ?? false
    tag.setFollowingStateTo(!isCurrentlyFollowed)
    
    let completeHandler: CompleteHandler = { [weak self] in
      guard let strongSelf = self else {
        return
      }
      
      strongSelf.initialRefresh()
      
      guard let error = $0 else {
        return
      }
      
      strongSelf.presenter.handleErrorSilently(error)
    }
    
    isCurrentlyFollowed ?
      tagService.unfollow(tag, complete: completeHandler):
      tagService.follow(tag, complete: completeHandler)
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
  
  func initialFetchData() {
    observableTag.observationHandler = { [weak self] in
      self?.presenter.presentTag($0)
    }
    
    observableTag.performFetch { [weak self] in
      switch $0 {
      case .success(let tag):
        if let tag = tag {
          self?.presenter.presentTag(tag)
        }
      case .failure(let error):
        self?.presenter.handleError(error)
      }
    }
    
    do {
      try fetchResultController.performFetch()
    } catch {
      presenter.handleError(error)
    }
  }
  
  func initialRefresh() {
    tagService.getRelatedPostsFor(tagForPresentation, page: 1, perPage: 3) { [weak self] in
      guard let strongSelf = self else {
        return
      }
      
      switch $0 {
      case .success(let tag, let relatedTags, _, _):
        let tagsRelations = TagsRelations.related(tag: tag, to: relatedTags)
        strongSelf.coreDataStorage.batchUpdateStorage(with: [tagsRelations])
      case .failure(let error):
        strongSelf.presenter.handleError(error)
      }
    }
  }
}

// MARK: - Interactor Viper Components Api
private extension SearchResultTagDetailContentInteractor {
  var presenter: SearchResultTagDetailContentPresenterApi {
    return _presenter as! SearchResultTagDetailContentPresenterApi
  }
}

//MARK:- Helpers

extension SearchResultTagDetailContentInteractor {
  fileprivate func fetchPredicate() -> NSPredicate? {
    return NSPredicate(format: "ANY relatedTags.id = \(tagForPresentation.identifier)")
  }
  
  fileprivate func sortDesriptors() -> [NSSortDescriptor] {
    return [NSSortDescriptor(key: #keyPath(TagManagedObject.id), ascending: true)]
  }
}

//MARK:- FetchedResultsControllerDelegate

extension SearchResultTagDetailContentInteractor: FetchedResultsControllerDelegate {
  func updateItems(_ proxy: FetchedResultsControllerDelegateProxy, updates: CollectionViewModelUpdate) {
    presenter.presentCollectionUpdates(updates)
  }
}

