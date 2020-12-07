//
//  GoodsOrder+StorageExtensions.swift
//  Pibble-iOS
//
//  Created by Sergey Kazakov on 07/08/2019.
//  Copyright © 2019 com.kazai. All rights reserved.
//

import CoreData

extension GoodsOrderManagedObject: MappableManagedObject {
  typealias ID = Int32
  
  static func replaceOrCreate(with object: GoodsOrderProtocol, in context: NSManagedObjectContext) -> GoodsOrderManagedObject {
    let managedObject = GoodsOrderManagedObject.findOrCreate(with: object.identifier, in: context)
    
    managedObject.id = Int32(object.identifier)
    managedObject.uuid = object.orderUUID
    managedObject.status = object.orderStatus.rawValue
    managedObject.price = NSDecimalNumber(value: object.orderPrice)
    
    managedObject.createdAt = object.orderCreatedAt.toNSDate
    managedObject.updatedAt = object.orderUpdatedAt.toNSDate
    return managedObject
  }
}

extension GoodsOrderManagedObject: GoodsOrderProtocol {
  var identifier: Int {
    return Int(id)
  }
  
  var orderUUID: String {
    return uuid ?? ""
  }
  
  var orderStatus: GoodsOrderStatus {
    return GoodsOrderStatus(rawValue: status ?? "")
  }
  
  var orderPrice: Double {
    return price?.doubleValue ?? 0.0
  }
  
  var orderCreatedAt: Date {
    return createdAt?.toDate ?? Date(timeIntervalSince1970: 0.0)
  }
  
  var orderUpdatedAt: Date {
    return updatedAt?.toDate ?? Date(timeIntervalSince1970: 0.0)
  }
}

extension GoodsOrderProtocol {
  func updateOrCreateManagedObject(in context: NSManagedObjectContext) {
    let _ = GoodsOrderManagedObject.replaceOrCreate(with: self, in: context)
  }
  
  func delete(in context: NSManagedObjectContext) {
    let managedObject = GoodsOrderManagedObject.replaceOrCreate(with: self, in: context)
    context.delete(managedObject)
  }
}
