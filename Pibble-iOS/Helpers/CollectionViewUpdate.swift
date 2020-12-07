//
//  CollectionViewUpdate.swift
//  Pibble
//
//  Created by Kazakov Sergey on 01.07.2018.
//  Copyright © 2018 com.kazai. All rights reserved.
//

import Foundation


enum CollectionViewModelUpdate {
  case beginUpdates
  case endUpdates
  case insert(idx: [IndexPath])
  case delete(idx: [IndexPath])
  case insertSections(idx: [Int])
  case deleteSections(idx: [Int])
  case updateSections(idx: [Int])
  case moveSections(from: Int, to: Int)
  case update(idx: [IndexPath])
  case move(from: IndexPath, to: IndexPath)
  case reloadData
}


struct CollectionViewUpdate {
  let moveFromTo: [(IndexPath, IndexPath)]
  let insertAt: [IndexPath]
  let removeAt: [IndexPath]
  let reloadAt: [IndexPath]
  let reloadSections: [Int]
  
  init(moveFromTo: [(IndexPath, IndexPath)] = [],
    insertAt: [IndexPath] = [],
    removeAt: [IndexPath] = [],
    reloadAt: [IndexPath] = [],
    reloadSections: [Int] = []) {
    
    self.moveFromTo = moveFromTo
    self.insertAt = insertAt
    self.removeAt = removeAt
    self.reloadAt = reloadAt
    self.reloadSections = reloadSections
    
  }
  
}
