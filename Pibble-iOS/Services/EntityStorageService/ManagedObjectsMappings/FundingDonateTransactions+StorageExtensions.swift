//
//  CrowdFundingDonateTransaction+StorageExtensions.swift
//  Pibble-iOS
//
//  Created by Sergey Kazakov on 10/09/2019.
//  Copyright © 2019 com.kazai. All rights reserved.
//

import CoreData

extension CharityFundingDonateTransactionManagedObject: MappableManagedObject {
    static func replaceOrCreate(with object: CharityFundingDonateTransactionProtocol, in context: NSManagedObjectContext) -> CharityFundingDonateTransactionManagedObject {
  
      let managedObject = CharityFundingDonateTransactionManagedObject.findOrCreate(with: object.identifier, in: context)
      managedObject.replace(with: object, in: context)
      
      if let user = object.activityFromUser {
        managedObject.fromUser = UserManagedObject.replaceOrCreate(with: user, in: context)
      }
      
      return managedObject
    }
  
    static func updateOrCreate(with object: PartialCharityFundingDonateTransactionProtocol, in context: NSManagedObjectContext) -> CharityFundingDonateTransactionManagedObject {
  
      let managedObject = CharityFundingDonateTransactionManagedObject.findOrCreate(with: object.identifier, in: context)
      managedObject.update(with: object, in: context)
      
      if let user = object.activityFromUser {
        managedObject.fromUser = UserManagedObject.updateOrCreate(with: user, in: context)
      }
      
      return managedObject
    }
}

extension CharityFundingDonateTransactionManagedObject: CharityFundingDonateTransactionProtocol {
  var activityFromUser: UserProtocol? {
    return fromUser
  }
}

extension CrowdFundingDonateTransactionManagedObject: MappableManagedObject {
  static func replaceOrCreate(with object: CrowdFundingDonateTransactionProtocol, in context: NSManagedObjectContext) -> CrowdFundingDonateTransactionManagedObject {
    
    let managedObject = CrowdFundingDonateTransactionManagedObject.findOrCreate(with: object.identifier, in: context)
    managedObject.replace(with: object, in: context)
    
    if let user = object.activityFromUser {
      managedObject.fromUser = UserManagedObject.replaceOrCreate(with: user, in: context)
    }
    
    return managedObject
  }
  
  static func updateOrCreate(with object: PartialCrowdFundingDonateTransactionProtocol, in context: NSManagedObjectContext) -> CrowdFundingDonateTransactionManagedObject {
    
    let managedObject = CrowdFundingDonateTransactionManagedObject.findOrCreate(with: object.identifier, in: context)
    managedObject.update(with: object, in: context)
    
    if let user = object.activityFromUser {
      managedObject.fromUser = UserManagedObject.updateOrCreate(with: user, in: context)
    }
    
    return managedObject
  }
}

extension CrowdFundingDonateTransactionManagedObject: CrowdFundingDonateTransactionProtocol {
  var activityFromUser: UserProtocol? {
    return fromUser
  }
}

extension CrowdFundingWithRewardsDonateTransactionManagedObject: MappableManagedObject {
  static func replaceOrCreate(with object: CrowdFundingWithRewardsDonateTransactionProtocol, in context: NSManagedObjectContext) -> CrowdFundingWithRewardsDonateTransactionManagedObject {
    
    let managedObject = CrowdFundingWithRewardsDonateTransactionManagedObject.findOrCreate(with: object.identifier, in: context)
    managedObject.replace(with: object, in: context)
    
    managedObject.priceTitle = object.rewardPriceTitle
    
    if let user = object.activityFromUser {
      managedObject.fromUser = UserManagedObject.replaceOrCreate(with: user, in: context)
    }
    
    return managedObject
  }
  
  static func updateOrCreate(with object: PartialCrowdFundingWithRewardsDonateTransactionProtocol, in context: NSManagedObjectContext) -> CrowdFundingWithRewardsDonateTransactionManagedObject {
    
    let managedObject = CrowdFundingWithRewardsDonateTransactionManagedObject.findOrCreate(with: object.identifier, in: context)
    managedObject.update(with: object, in: context)
    
    managedObject.priceTitle = object.rewardPriceTitle
    
    if let user = object.activityFromUser {
      managedObject.fromUser = UserManagedObject.updateOrCreate(with: user, in: context)
    }
    
    return managedObject
  }
}

extension CrowdFundingWithRewardsDonateTransactionManagedObject: CrowdFundingWithRewardsDonateTransactionProtocol {
  var rewardPriceTitle: String {
    return priceTitle ?? ""
  }
  
  var activityFromUser: UserProtocol? {
    return fromUser
  }
}
