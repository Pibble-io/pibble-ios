//
//  SearchResultEntity+StorageExtensions.swift
//  Pibble
//
//  Created by Kazakov Sergey on 30.12.2018.
//  Copyright © 2018 com.kazai. All rights reserved.
//

import Foundation
import CoreData

extension SearchResultEntity: BaseSearchResultProtocol, CoreDataStorableEntity {
  func updateOrCreateManagedObject(in context: NSManagedObjectContext) {
    switch self {
    case .user(let entity):
      let _ = UserSearchResultManagedObject.replaceOrCreate(with: entity, in: context)
    case .place(let entity):
      let _ = LocationSearchResultManagedObject.replaceOrCreate(with: entity, in: context)
    case .tag(let entity):
      let _ = TagSearchResultManagedObject.replaceOrCreate(with: entity, in: context)
    }
  }
  
  func delete(in context: NSManagedObjectContext) {
    let managedObject: NSManagedObject
    switch self {
    case .user(let entity):
      managedObject = UserSearchResultManagedObject.replaceOrCreate(with: entity, in: context)
    case .place(let entity):
      managedObject = LocationSearchResultManagedObject.replaceOrCreate(with: entity, in: context)
    case .tag(let entity):
      managedObject = TagSearchResultManagedObject.replaceOrCreate(with: entity, in: context)
    }
    
    context.delete(managedObject)
  }
  
  fileprivate var searchResultEntity: BaseSearchResultProtocol {
    switch self {
    case .user(let searchResult):
      return searchResult
    case .place(let searchResult):
      return searchResult
    case .tag(let searchResult):
      return searchResult
    }
  }
  
  var identifier: Int {
    return searchResultEntity.identifier
  }
  
  var searchResultType: SearchResultType {
    return searchResultEntity.searchResultType
  }
  
  var searchResultCreatedAt: Date {
    return searchResultEntity.searchResultCreatedAt
  }
  
  var searchString: String {
    return searchResultEntity.searchString
  }
}
