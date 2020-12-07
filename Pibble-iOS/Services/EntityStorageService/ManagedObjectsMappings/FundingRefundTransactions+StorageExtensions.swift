//
//  RefundTransactions+StorageExtensions.swift
//  Pibble-iOS
//
//  Created by Sergey Kazakov on 10/09/2019.
//  Copyright © 2019 com.kazai. All rights reserved.
//

import CoreData

extension CharityFundingRefundTransactionManagedObject: MappableManagedObject {
  static func replaceOrCreate(with object: CharityFundingRefundTransactionProtocol, in context: NSManagedObjectContext) -> CharityFundingRefundTransactionManagedObject {
    
    let managedObject = CharityFundingRefundTransactionManagedObject.findOrCreate(with: object.identifier, in: context)
    managedObject.replace(with: object, in: context)
    return managedObject
  }
  
  static func updateOrCreate(with object: PartialCharityFundingRefundTransactionProtocol, in context: NSManagedObjectContext) -> CharityFundingRefundTransactionManagedObject {
    
    let managedObject = CharityFundingRefundTransactionManagedObject.findOrCreate(with: object.identifier, in: context)
    managedObject.update(with: object, in: context)
    return managedObject
  }
}

extension CharityFundingRefundTransactionManagedObject: CharityFundingRefundTransactionProtocol {
  
}


extension CrowdFundingRefundTransactionManagedObject: MappableManagedObject {
  static func replaceOrCreate(with object: CrowdFundingRefundTransactionProtocol, in context: NSManagedObjectContext) -> CrowdFundingRefundTransactionManagedObject {
    
    let managedObject = CrowdFundingRefundTransactionManagedObject.findOrCreate(with: object.identifier, in: context)
    managedObject.replace(with: object, in: context)
    return managedObject
  }
  
  static func updateOrCreate(with object: PartialCrowdFundingRefundTransactionProtocol, in context: NSManagedObjectContext) -> CrowdFundingRefundTransactionManagedObject {
    
    let managedObject = CrowdFundingRefundTransactionManagedObject.findOrCreate(with: object.identifier, in: context)
    managedObject.update(with: object, in: context)
    return managedObject
  }
}

extension CrowdFundingRefundTransactionManagedObject: CrowdFundingRefundTransactionProtocol {
  
}

extension CrowdFundingWithRewardsRefundTransactionManagedObject: MappableManagedObject {
  static func replaceOrCreate(with object: CrowdFundingWithRewardsRefundTransactionProtocol, in context: NSManagedObjectContext) -> CrowdFundingWithRewardsRefundTransactionManagedObject {
    
    let managedObject = CrowdFundingWithRewardsRefundTransactionManagedObject.findOrCreate(with: object.identifier, in: context)
    managedObject.replace(with: object, in: context)
    return managedObject
  }
  
  static func updateOrCreate(with object: PartialCrowdFundingWithRewardsRefundTransactionProtocol, in context: NSManagedObjectContext) -> CrowdFundingWithRewardsRefundTransactionManagedObject {
    
    let managedObject = CrowdFundingWithRewardsRefundTransactionManagedObject.findOrCreate(with: object.identifier, in: context)
    managedObject.update(with: object, in: context)
    return managedObject
  }
}

extension CrowdFundingWithRewardsRefundTransactionManagedObject: CrowdFundingWithRewardsRefundTransactionProtocol {
  
}
