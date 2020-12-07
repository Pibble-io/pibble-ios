//
//  UserSearchResult+StorageExtensions.swift
//  Pibble
//
//  Created by Kazakov Sergey on 30.12.2018.
//  Copyright © 2018 com.kazai. All rights reserved.
//

import Foundation
import CoreData

extension UserSearchResultManagedObject: MappableManagedObject {
  typealias ID = Int32
  
  fileprivate func update(with object: UserSearchResultProtocol, in context: NSManagedObjectContext) -> Self {
    id = Int32(object.identifier)
    searchKey = object.searchString
    resultType = Int32(object.searchResultType.rawValue)
    createdAt = NSDate(timeIntervalSince1970: object.searchResultCreatedAt.timeIntervalSince1970)
    
    if let user = object.user {
      relatedUser = UserManagedObject.replaceOrCreate(with: user, in: context)
    }
    
    return self
  }
  
  static func replaceOrCreate(with object: UserSearchResultProtocol, in context: NSManagedObjectContext) -> UserSearchResultManagedObject {
    
    let managedObject = UserSearchResultManagedObject.findOrCreate(with: object.identifier, in: context)
    return managedObject.update(with: object, in: context)
  }
}

extension UserSearchResultManagedObject: UserSearchResultProtocol {
  var user: UserProtocol? {
    return relatedUser
  }
}

extension UserSearchResultProtocol {
  func updateOrCreateManagedObject(in context: NSManagedObjectContext) {
    let _ = UserSearchResultManagedObject.replaceOrCreate(with: self, in: context)
  }
  
  func delete(in context: NSManagedObjectContext) {
    let managedObject = UserSearchResultManagedObject.replaceOrCreate(with: self, in: context)
    context.delete(managedObject)
  }
}
