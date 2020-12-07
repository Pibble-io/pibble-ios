//
//  Goods+StorageExtensions.swift
//  Pibble-iOS
//
//  Created by Sergey Kazakov on 02/08/2019.
//  Copyright © 2019 com.kazai. All rights reserved.
//

import CoreData

extension GoodsManagedObject: MappableManagedObject {
  typealias ID = Int32

  static func replaceOrCreate(with object: GoodsProtocol, in context: NSManagedObjectContext) -> GoodsManagedObject {
    let managedObject = GoodsManagedObject.findOrCreate(with: object.identifier, in: context)
    managedObject.id = Int32(object.identifier)
    managedObject.title = object.goodsTitle
    managedObject.price = NSDecimalNumber(value: object.goodsPrice)
    managedObject.isNewState = object.isNewGoodsStatus
    managedObject.status = object.availabilityStatus.rawValue
    managedObject.site = object.goodsUrlString
    managedObject.descriptionText = object.goodsDescription
    managedObject.createdAt = object.goodsCreatedAt.toNSDate
    managedObject.updatedAt = object.goodsUpdatedAt.toNSDate
  
    return managedObject
  }
}

extension GoodsManagedObject: GoodsProtocol {
  var identifier: Int {
    return Int(id)
  }
  
  var goodsTitle: String {
    return title ?? ""
  }
  
  var goodsPrice: Double {
    return price?.doubleValue ?? 0.0
  }
  
  var isNewGoodsStatus: Bool {
    return isNewState
  }
  
  var availabilityStatus: GoodsAvailabilityStatus {
    return GoodsAvailabilityStatus(rawValue: status ?? "")
  }
  
  var goodsUrlString: String {
    return site ?? ""
  }
  
  var goodsDescription: String {
    return descriptionText ?? ""
  }
  
  var goodsCreatedAt: Date {
    return createdAt?.toDate ?? Date(timeIntervalSince1970: 0.0)
  }
  
  var goodsUpdatedAt: Date {
    return updatedAt?.toDate ?? Date(timeIntervalSince1970: 0.0)
  }
}

extension GoodsProtocol {
  func updateOrCreateManagedObject(in context: NSManagedObjectContext) {
    let _ = GoodsManagedObject.replaceOrCreate(with: self, in: context)
  }
  
  func delete(in context: NSManagedObjectContext) {
    let managedObject = GoodsManagedObject.replaceOrCreate(with: self, in: context)
    context.delete(managedObject)
  }
}
