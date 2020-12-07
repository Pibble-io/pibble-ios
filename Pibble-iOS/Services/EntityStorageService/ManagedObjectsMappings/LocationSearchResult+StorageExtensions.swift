//
//  PlaceSearchResult+StorageExtensions.swift
//  Pibble
//
//  Created by Kazakov Sergey on 30.12.2018.
//  Copyright © 2018 com.kazai. All rights reserved.
//

import Foundation

import Foundation
import CoreData

extension LocationSearchResultManagedObject: MappableManagedObject {
  typealias ID = Int32
  
  fileprivate func update(with object: PlaceSearchResultProtocol, in context: NSManagedObjectContext) -> Self {
    id = Int32(object.identifier)
    searchKey = object.searchString
    resultType = Int32(object.searchResultType.rawValue)
    createdAt = NSDate(timeIntervalSince1970: object.searchResultCreatedAt.timeIntervalSince1970)
    
    if let place = object.place {
      relatedLocation = LocationManagedObject.replaceOrCreate(with: place, in: context)
    }
    
    return self
  }
  
  static func replaceOrCreate(with object: PlaceSearchResultProtocol, in context: NSManagedObjectContext) -> LocationSearchResultManagedObject {
    
    let managedObject = LocationSearchResultManagedObject.findOrCreate(with: object.identifier, in: context)
    return managedObject.update(with: object, in: context)
  }
}

extension LocationSearchResultManagedObject: PlaceSearchResultProtocol {
  var place: LocationProtocol? {
    return relatedLocation
  }
}

extension PlaceSearchResultProtocol {
  func updateOrCreateManagedObject(in context: NSManagedObjectContext) {
    let _ = LocationSearchResultManagedObject.replaceOrCreate(with: self, in: context)
  }
  
  func delete(in context: NSManagedObjectContext) {
    let managedObject = LocationSearchResultManagedObject.replaceOrCreate(with: self, in: context)
    context.delete(managedObject)
  }
}
