//
//  ArrayDiffExtensions.swift
//  Pibble
//
//  Created by Kazakov Sergey on 22.09.2018.
//  Copyright © 2018 com.kazai. All rights reserved.
//

import Foundation


struct DiffableSection<ID: DiffableProtocol, Element> {
  let id: ID
  let items: [Element]
}

protocol DiffableProtocol {
  var identifier: String  { get }
}

struct Diff {
  let insertedIndices: [Int]
  let deletedIndices: [Int]
  let updateIndices: [Int]
  let movedIndices: [(from: Int, to: Int)]
}


//array of diffables is also diffable

extension DiffableSection: DiffableProtocol {
  var identifier: String {
    return id.identifier
  }
}

extension Array: DiffableProtocol where Element: DiffableProtocol {
  var identifier: String {
    return self.map { $0.identifier }.joined(separator: "_")
  }
}

extension String: DiffableProtocol {
  var identifier: String {
    return self
  }
}

extension Int: DiffableProtocol {
  var identifier: String {
    return "\(self)"
  }
}
//O(n) implementation of two arrays diff algo

extension Array where Element: DiffableProtocol {
  func diff<T: DiffableProtocol>(before: [T]) -> Diff {
    let after = self
    // A dictionary mapping each id to a pair
    //    ( oldIndex, newIndex )
    // where oldIndex = nil for inserted elements
    // and newIndex = nil for deleted elements.
    var map : [ String : (from: Int?, to: Int?)] = [:]
    
    // Add [ id : (from, nil) ] for each id in before:
    for (idx, elem) in before.enumerated() {
      map[elem.identifier] = (from: idx, to: nil)
    }
    
    // Update [ id : (from, to) ] or add [ id : (nil, to) ] for each id in after:
    for (idx, elem) in after.enumerated() {
      map[elem.identifier] = (map[elem.identifier]?.from, idx)
    }
    
    // Compare:
    var insertedIndices : [Int] = []
    var deletedIndices : [Int] = []
    var movedIndices : [(from: Int, to: Int)] = []
    let updateIndices: [Int] = []
  
    for pair in map.values {
      switch pair {
      case (let .some(fromIdx), let .some(toIdx)):
        if fromIdx != toIdx {
          movedIndices.append((from: fromIdx, to: toIdx))
        }
      case (let .some(fromIdx), .none):
        deletedIndices.append(fromIdx)
      case (.none, let .some(toIdx)):
        insertedIndices.append(toIdx)
      default:
        fatalError("Oops") // This should not happen!
      }
    }
//    
//    var insertIndecesSet = Set(insertedIndices)
//    var deleteIndecesSet = Set(deletedIndices)
//    var updateIndicesSet = insertIndecesSet.intersection(deleteIndecesSet)
//    
//    insertIndecesSet.subtract(updateIndicesSet)
//    deleteIndecesSet.subtract(updateIndicesSet)
//    
//    updateIndicesSet.subtract(movedIndices.map { return $0.from })
//    updateIndicesSet.subtract(movedIndices.map { return $0.to })
//    
//    insertedIndices = Array<Int>(insertIndecesSet)
//    deletedIndices = Array<Int>(deleteIndecesSet)
//    updateIndices = Array<Int>(updateIndicesSet)

    let diff = Diff(insertedIndices: insertedIndices,
                    deletedIndices: deletedIndices,
                    updateIndices: updateIndices,
                    movedIndices: movedIndices)
    
    return diff
  }
}


extension Diff {
  func collectionViewUpdatesForSection(_ section: Int) -> [CollectionViewModelUpdate] {
    let insert = [CollectionViewModelUpdate.insert(idx: insertedIndices.map { IndexPath(item: $0, section: section) })]
    let delete = [CollectionViewModelUpdate.delete(idx: deletedIndices.map { IndexPath(item: $0, section: section) })]
    let update = [CollectionViewModelUpdate.update(idx: updateIndices.map { IndexPath(item: $0, section: section) })]
    
    let moves = movedIndices.map {
      return CollectionViewModelUpdate.move(from: IndexPath(item: $0.from, section: section),
                                            to:  IndexPath(item: $0.to, section: section))
    }
    
    return [insert, delete, update, moves].flatMap { $0 }
  }
}
