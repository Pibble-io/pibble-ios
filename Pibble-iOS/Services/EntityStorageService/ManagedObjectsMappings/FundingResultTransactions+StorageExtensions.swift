//
//  FundingResultTransactions+StorageExtensions.swift
//  Pibble-iOS
//
//  Created by Sergey Kazakov on 10/09/2019.
//  Copyright © 2019 com.kazai. All rights reserved.
//

import CoreData

extension CharityFundingResultTransactionManagedObject: MappableManagedObject {
  static func replaceOrCreate(with object: CharityFundingResultTransactionProtocol, in context: NSManagedObjectContext) -> CharityFundingResultTransactionManagedObject {
    
    let managedObject = CharityFundingResultTransactionManagedObject.findOrCreate(with: object.identifier, in: context)
    managedObject.replace(with: object, in: context)
    return managedObject
  }
  
  static func updateOrCreate(with object: PartialCharityFundingResultTransactionProtocol, in context: NSManagedObjectContext) -> CharityFundingResultTransactionManagedObject {
    
    let managedObject = CharityFundingResultTransactionManagedObject.findOrCreate(with: object.identifier, in: context)
    managedObject.update(with: object, in: context)
    return managedObject
  }
}

extension CharityFundingResultTransactionManagedObject: CharityFundingResultTransactionProtocol {
  
}

extension CrowdFundingResultTransactionManagedObject: MappableManagedObject {
  static func replaceOrCreate(with object: CrowdFundingResultTransactionProtocol, in context: NSManagedObjectContext) -> CrowdFundingResultTransactionManagedObject {
    
    let managedObject = CrowdFundingResultTransactionManagedObject.findOrCreate(with: object.identifier, in: context)
    managedObject.replace(with: object, in: context)
    return managedObject
  }
  
  static func updateOrCreate(with object: PartialCrowdFundingResultTransactionProtocol, in context: NSManagedObjectContext) -> CrowdFundingResultTransactionManagedObject {
    
    let managedObject = CrowdFundingResultTransactionManagedObject.findOrCreate(with: object.identifier, in: context)
    managedObject.update(with: object, in: context)
    return managedObject
  }
}

extension CrowdFundingResultTransactionManagedObject: CrowdFundingResultTransactionProtocol {
  
}

extension CrowdFundingWithRewardsResultTransactionManagedObject: MappableManagedObject {
  static func replaceOrCreate(with object: CrowdFundingWithRewardsResultTransactionProtocol, in context: NSManagedObjectContext) -> CrowdFundingWithRewardsResultTransactionManagedObject {
    
    let managedObject = CrowdFundingWithRewardsResultTransactionManagedObject.findOrCreate(with: object.identifier, in: context)
    managedObject.replace(with: object, in: context)
    return managedObject
  }
  
  static func updateOrCreate(with object: PartialCrowdFundingWithRewardsResultTransactionProtocol, in context: NSManagedObjectContext) -> CrowdFundingWithRewardsResultTransactionManagedObject {
    
    let managedObject = CrowdFundingWithRewardsResultTransactionManagedObject.findOrCreate(with: object.identifier, in: context)
    managedObject.update(with: object, in: context)
    return managedObject
  }
}

extension CrowdFundingWithRewardsResultTransactionManagedObject: CrowdFundingWithRewardsResultTransactionProtocol {
  
}
