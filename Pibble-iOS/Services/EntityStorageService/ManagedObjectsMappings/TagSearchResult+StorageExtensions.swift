//
//  TagSearchResult+StorageExtensions.swift
//  Pibble
//
//  Created by Kazakov Sergey on 30.12.2018.
//  Copyright © 2018 com.kazai. All rights reserved.
//

import Foundation
import CoreData

extension TagSearchResultManagedObject: MappableManagedObject {
  typealias ID = Int32
  
  fileprivate func update(with object: TagSearchResultProtocol, in context: NSManagedObjectContext) -> Self {
    id = Int32(object.identifier)
    searchKey = object.searchString
    resultType = Int32(object.searchResultType.rawValue)
    createdAt = NSDate(timeIntervalSince1970: object.searchResultCreatedAt.timeIntervalSince1970)
    
    if let tag = object.tag {
      relatedTag = TagManagedObject.replaceOrCreate(with: tag, in: context)
    }
    
    return self
  }
  
  static func replaceOrCreate(with object: TagSearchResultProtocol, in context: NSManagedObjectContext) -> TagSearchResultManagedObject {
    
    let managedObject = TagSearchResultManagedObject.findOrCreate(with: object.identifier, in: context)
    return managedObject.update(with: object, in: context)
  }
}

extension TagSearchResultManagedObject: TagSearchResultProtocol {
  var tag: TagProtocol? {
    return relatedTag
  }
}

extension TagSearchResultProtocol {
  func updateOrCreateManagedObject(in context: NSManagedObjectContext) {
    let _ = TagSearchResultManagedObject.replaceOrCreate(with: self, in: context)
  }
  
  func delete(in context: NSManagedObjectContext) {
    let managedObject = TagSearchResultManagedObject.replaceOrCreate(with: self, in: context)
    context.delete(managedObject)
  }
}
