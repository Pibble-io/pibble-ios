//
//  InteractionEvent+StorageExtension.swift
//  Pibble
//
//  Created by Sergey Kazakov on 15/06/2019.
//  Copyright © 2019 com.kazai. All rights reserved.
//

import CoreData

extension InteractionEventManagedObject: MappableManagedObject {
  typealias ID = String?
  
  fileprivate func update(with object: InteractionEventProtocol, in context: NSManagedObjectContext) -> Self {
    id = object.identifier
    type = object.eventType.rawValue
    postId = Int32(object.postIdentifier)
    userId = Int32(object.userIndentifier)
    date = NSDate(timeIntervalSince1970: object.eventDate.timeIntervalSince1970)
    
    if let promoIndentifier = object.promoIndentifier {
      promoId = String(promoIndentifier)
    }
    
    if let eventValue = object.eventValue {
      value = String(eventValue)
    }
    
    return self
  }
  
  static func replaceOrCreate(with object: InteractionEventProtocol, in context: NSManagedObjectContext) -> InteractionEventManagedObject {
    
    let managedObject = InteractionEventManagedObject.findOrCreate(with: InteractionEventManagedObject.ID(object.identifier), in: context)
    return managedObject.update(with: object, in: context)
  }
}

extension InteractionEventProtocol {
  func updateOrCreateManagedObject(in context: NSManagedObjectContext) {
    let _ = InteractionEventManagedObject.replaceOrCreate(with: self, in: context)
  }
  
  func delete(in context: NSManagedObjectContext) {
    let managedObject = InteractionEventManagedObject.replaceOrCreate(with: self, in: context)
    context.delete(managedObject)
  }
}

extension InteractionEventManagedObject: InteractionEventProtocol {
  var identifier: String {
    return id ?? ""
  }
  
  var eventType: TrackedEventType {
    return TrackedEventType(rawValue: type ?? "") ?? .impression
  }
  
  var postIdentifier: Int {
    return Int(postId)
  }
  
  var userIndentifier: Int {
    return Int(userId)
  }
  
  var promoIndentifier: Int? {
    if let promoId = promoId {
      return Int(promoId)
    }
    
    return nil
  }
  
  var eventDate: Date {
    if let date = date {
      return Date(timeIntervalSince1970: date.timeIntervalSince1970)
    }
    
    return Date()
  }
  
  var eventValue: Double? {
    guard let value = value else {
      return nil
    }
    
    return Double(value)
  }
}
