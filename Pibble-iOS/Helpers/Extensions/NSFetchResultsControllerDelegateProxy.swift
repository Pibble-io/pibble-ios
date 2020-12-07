//
//  NSFetchResultsControllerDelegateProxy.swift
//  Pibble
//
//  Created by Kazakov Sergey on 06.08.2018.
//  Copyright © 2018 com.kazai. All rights reserved.
//

import Foundation
import CoreData

class FetchedResultsControllerDelegateProxy: NSObject {
  fileprivate weak var delegate: FetchedResultsControllerDelegate?
  fileprivate var batchUpdates: [CollectionViewModelUpdate] = []
  
  var isEnabled: Bool = true {
    didSet {
      updateItems(updates: .reloadData)
    }
  }
  
  fileprivate var isUpdating: Bool = false
  
  init(delegate: FetchedResultsControllerDelegate) {
    self.delegate = delegate
  }
}

extension FetchedResultsControllerDelegateProxy: NSFetchedResultsControllerDelegate {
  func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
    guard isEnabled else {
      return
    }
    
    isUpdating = true
    updateItems(updates: .beginUpdates)
  }
  
  func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
    guard isEnabled else {
      return
    }
    
    updateItems(updates: .endUpdates)
    isUpdating = false
  }
  
  func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                  didChange sectionInfo: NSFetchedResultsSectionInfo,
                  atSectionIndex sectionIndex: Int,
                  for type: NSFetchedResultsChangeType) {
    
    guard isEnabled else {
      return
    }
    
    switch (type) {
    case .insert:
      updateItems(updates: .insertSections(idx: [sectionIndex]))
    case .delete:
      updateItems(updates: .deleteSections(idx: [sectionIndex]))
    case .update:
      updateItems(updates: .updateSections(idx: [sectionIndex]))
    default:
      break
    }
    
  }
  
  func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
    
    guard isEnabled else {
      return
    }
    
    switch type {
    case .insert:
      updateItems(updates: .insert(idx: [newIndexPath!]))
    case .delete:
      updateItems(updates: .delete(idx: [indexPath!]))
    case .update:
      updateItems(updates: .update(idx: [indexPath!]))
    case .move:
      
      guard let indexPath = indexPath, let newIndexPath = newIndexPath else {
        return
      }
      
      if indexPath != newIndexPath {
        updateItems(updates: .delete(idx: [indexPath]))
        updateItems(updates: .insert(idx: [newIndexPath]))
      }
    }
  }
  
  fileprivate func updateItems(updates: CollectionViewModelUpdate) {
    if case CollectionViewModelUpdate.reloadData = updates {
      batchUpdates = []
      delegate?.updateItems(self, updates: .reloadData)
      return
    }
    
    guard case CollectionViewModelUpdate.endUpdates = updates else {
      batchUpdates.append(updates)
      return
    }
    
    batchUpdates.append(updates)
    let updates = batchUpdates
    batchUpdates = []
    updates.forEach {
      delegate?.updateItems(self, updates: $0)
    }
  }
}

protocol FetchedResultsControllerDelegate: class {
  func updateItems(_ proxy: FetchedResultsControllerDelegateProxy, updates: CollectionViewModelUpdate)
}
