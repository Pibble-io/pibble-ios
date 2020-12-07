//
//  FRCBackedInteractor.swift
//  Pibble
//
//  Created by Sergey Kazakov on 20/03/2019.
//  Copyright © 2019 com.kazai. All rights reserved.
//

import CoreData

protocol FRCBackedInteractor: DataSubscribableInteractorProtocol {
  associatedtype T: NSManagedObject
  
  var fetchedResultsControllerDelegateProxy: FetchedResultsControllerDelegateProxy { get }
  
  var fetchResultController: NSFetchedResultsController<T> { get }
}

extension FRCBackedInteractor {
  fileprivate func subscribeToFRC() {
    guard fetchResultController.delegate == nil
      else {
        return
    }
    
    fetchResultController.delegate = fetchedResultsControllerDelegateProxy
  }
  
  fileprivate func unsubscribeToFRC() {
    fetchResultController.delegate = nil
  }
}

extension DataSubscribableInteractorProtocol where Self: FRCBackedInteractor {
  func subscribeDataUpdates() {
    subscribeToFRC()
  }
  
  func unsubscribeDataUpdates() {
    unsubscribeToFRC()
  }
}

protocol OptionalFRCBackedInteractor {
  associatedtype T: NSManagedObject
  
  var fetchedResultsControllerDelegateProxy: FetchedResultsControllerDelegateProxy { get }
  
  var fetchResultController: NSFetchedResultsController<T>? { get }
}

extension OptionalFRCBackedInteractor {
  fileprivate func subscribeToFRC() {
    guard let frc = fetchResultController,
      frc.delegate == nil
      else {
        return
    }
    
    frc.delegate = fetchedResultsControllerDelegateProxy
  }
  
  fileprivate func unsubscribeToFRC() {
    fetchResultController?.delegate = nil
  }
}
