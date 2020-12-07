//
//  Wallet+StrorageExtensions.swift
//  Pibble
//
//  Created by Kazakov Sergey on 15.10.2018.
//  Copyright © 2018 com.kazai. All rights reserved.
//

import Foundation
import CoreData

extension WalletManagedObject: MappableManagedObject {
  typealias ID = String?
  
  fileprivate func update(with object: WalletProtocol, in context: NSManagedObjectContext) -> Self {
    id = object.walletAddress
    currency = object.walletCurrency.rawValue
    return self
  }
  
  static func replaceOrCreate(with object: WalletProtocol, in context: NSManagedObjectContext) -> WalletManagedObject {
    
    let managedObject = WalletManagedObject.findOrCreate(with: WalletManagedObject.ID(object.walletAddress), in: context)
    return managedObject.update(with: object, in: context)
  }
}

extension WalletManagedObject: WalletProtocol {
  var walletCurrency: BalanceCurrency {
    return BalanceCurrency(rawValue: currency ?? "") 
  }
  
  var walletAddress: String {
    return id ?? ""
  }
}

extension WalletProtocol {
  func updateOrCreateManagedObject(in context: NSManagedObjectContext) {
    let _ = WalletManagedObject.replaceOrCreate(with: self, in: context)
  }
  
  func delete(in context: NSManagedObjectContext) {
    let managedObject = WalletManagedObject.replaceOrCreate(with: self, in: context)
    context.delete(managedObject)
  }
}

