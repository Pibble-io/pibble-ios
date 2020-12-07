//
//  Promotion+StrorageExtensions.swift
//  Pibble
//
//  Created by Kazakov Sergey on 04.12.2018.
//  Copyright © 2018 com.kazai. All rights reserved.
//

import Foundation
import CoreData

extension PromotionManagedObject: MappableManagedObject {
  typealias ID = Int32
  
  static func replaceOrCreate(with object: PostPromotionProtocol, in context: NSManagedObjectContext) -> PromotionManagedObject {
    let managedObject = PromotionManagedObject.findOrCreate(with: object.identifier, in: context)
  
    managedObject.id = Int32(object.identifier)
    managedObject.budget = NSDecimalNumber(value: object.promotionBudget)
    managedObject.duration = Int32(object.promotionDuration)
    managedObject.destination = object.promotionDestination.rawValue
    managedObject.actionTitle = object.promotionActionButton
    managedObject.destinationUrl = object.promotionUrlDestination
    managedObject.expirationDate = object.promotionExpirationDate.toNSDate
    
    let oldStatus = managedObject.status
    managedObject.status = object.promotionStatus.rawValue
   
    if managedObject.promotionExpirationDate.hasPassed {
      managedObject.status = PromotionStatus.closed.rawValue
    }
    
    if oldStatus != managedObject.status {
      managedObject.posting?.triggerRefresh()
    }
    
    return managedObject
  }
}

extension PromotionManagedObject {
  func changePauseStatus() {
    switch promotionStatus {
    case .active:
      setStatus(.paused)
    case .paused:
      setStatus(.active)
    case .closed:
      return
    }
  }
  
  func setStatus(_ status: PromotionStatus) {
    self.status = status.rawValue
    self.posting?.triggerRefresh()
  }
}

extension PromotionManagedObject: PostPromotionProtocol {
  var promotionExpirationDate: Date {
    return expirationDate?.toDate ?? Date(timeIntervalSince1970: 0.0)
  }
  
  var promotionDuration: Int {
    return Int(duration)
  }
  
  var promotionDestination: PromotionDestinationType {
    return PromotionDestinationType(rawValue: destination ?? "") ?? .profile
  }
  
  var promotionActionButton: String {
    return actionTitle ?? ""
  }
  
  var promotionUrlDestination: String? {
    return destinationUrl
  }
  
  var promotionStatus: PromotionStatus {
    return PromotionStatus(rawValue: status ?? "") ?? .active
  }
  
  var identifier: Int {
    return Int(id)
  }
  
  var promotionBudget: Double {
    return budget?.doubleValue ?? 0.0
  }
}

extension PostPromotionProtocol {
  func updateOrCreateManagedObject(in context: NSManagedObjectContext) {
    let _ = PromotionManagedObject.replaceOrCreate(with: self, in: context)
  }
  
  func delete(in context: NSManagedObjectContext) {
    let managedObject = PromotionManagedObject.replaceOrCreate(with: self, in: context)
    context.delete(managedObject)
  }
}
