//
//  MappableManagedObject.swift
//  Pibble
//
//  Created by Kazakov Sergey on 05.08.2018.
//  Copyright © 2018 com.kazai. All rights reserved.
//

import Foundation
import CoreData

protocol MappableManagedObject: PersistableManagedObject {
  associatedtype MappingObject
  associatedtype ManagedObject: NSManagedObject

  static func replaceOrCreate(with object: MappingObject, in context: NSManagedObjectContext) -> Self.ManagedObject
}

protocol ObservableManagedObjectProtocol: MappableManagedObject where ManagedObject: PersistableManagedObject {
  associatedtype MappingObject
  
  
  static func createObservable(with object: MappingObject, in context: NSManagedObjectContext) ->   ObservableManagedObject<ManagedObject>
}

