//
//  Location+StorageExtensions.swift
//  Pibble
//
//  Created by Kazakov Sergey on 03.08.2018.
//  Copyright © 2018 com.kazai. All rights reserved.
//

import Foundation
import CoreData

extension LocationManagedObject: MappableManagedObject {
  typealias ID = Int32
  
  static func replaceOrCreate(with object: LocationProtocol, in context: NSManagedObjectContext) -> LocationManagedObject {
    
    let managedObject = LocationManagedObject.findOrCreate(with: object.identifier, in: context)
    managedObject.id = Int32(object.identifier)
    managedObject.placeId = object.placeIdentifier
    managedObject.placeDescription = object.locationDescription
    managedObject.posted = Int32(object.postedCount)
    
    managedObject.latitude = object.placeLatitude
    managedObject.longitude = object.placeLongitude
    
    return managedObject
  }
}

extension LocationManagedObject: LocationProtocol {
  var placeLatitude: String {
    return latitude ?? ""
  }
  
  var placeLongitude: String {
    return longitude ?? ""
  }
  
  var postedCount: Int {
    return Int(posted)
  }
  
  var identifier: Int {
    return Int(id)
  }
  
  var placeIdentifier: String {
    return placeId ?? ""
  }
  
  var locationDescription: String {
    return placeDescription ?? ""
  }
}

extension LocationProtocol {
  func updateOrCreateManagedObject(in context: NSManagedObjectContext) {
    let _ = LocationManagedObject.replaceOrCreate(with: self, in: context)
  }
  
  func delete(in context: NSManagedObjectContext) {
    let managedObject = LocationManagedObject.replaceOrCreate(with: self, in: context)
    context.delete(managedObject)
  }
}
