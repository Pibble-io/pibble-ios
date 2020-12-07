//
//  FRCObservable.swift
//  Pibble
//
//  Created by Sergey Kazakov on 15/03/2019.
//  Copyright © 2019 com.kazai. All rights reserved.
//

import CoreData

typealias ObservationHandler<T> = (T) -> Void

class ObservableManagedObject<T: PersistableManagedObject & NSManagedObject> {
  
  var observationHandler: ObservationHandler<T>?
  
  var object: T? {
    return fetchedResultsController.sections?.first?.objects?.first as? T
  }
  
  fileprivate lazy var fetchedResultsControllerDelegateProxy: FetchedResultsControllerDelegateProxy = {
    FetchedResultsControllerDelegateProxy(delegate: self)
  }()
  
  fileprivate let fetchedResultsController: NSFetchedResultsController<T>
  
  init(_ id: T.ID, fetchRequest: NSFetchRequest<T>, context: NSManagedObjectContext) {
    let predicate = T.primaryKeyPredicateFor(id)
    
    fetchRequest.predicate = predicate
    fetchRequest.sortDescriptors = []
    fetchRequest.fetchLimit = 1
    
    fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
    
    fetchedResultsController.delegate = fetchedResultsControllerDelegateProxy
  }
  
  func performFetch(_ complete: ResultCompleteHandler<T?, PibbleError>) {
    do {
      try fetchedResultsController.performFetch()
      complete(Result(value:object))
    } catch {
      complete(Result(error:PibbleError.underlying(error)))
    }
  }
}

extension ObservableManagedObject: FetchedResultsControllerDelegate {
  func updateItems(_ proxy: FetchedResultsControllerDelegateProxy, updates: CollectionViewModelUpdate) {
    guard case CollectionViewModelUpdate.endUpdates = updates else {
      return
    }
    
    guard let object = object else {
      return
    }

    observationHandler?(object)
  }
}
