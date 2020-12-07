//
//  PersistbleObject.swift
//  Pibble
//
//  Created by Kazakov Sergey on 05.08.2018.
//  Copyright © 2018 com.kazai. All rights reserved.
//

import Foundation
import CoreData

protocol CoreDataStorableEntity {
  func updateOrCreateManagedObject(in context: NSManagedObjectContext)
  func delete(in context: NSManagedObjectContext)
}


