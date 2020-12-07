//
//  WalletManagedObject+CoreDataProperties.swift
//  
//
//  Created by Sergey Kazakov on 05/10/2019.
//
//

import Foundation
import CoreData


extension WalletManagedObject {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<WalletManagedObject> {
        return NSFetchRequest<WalletManagedObject>(entityName: "Wallet")
    }

    @NSManaged public var currency: String?
    @NSManaged public var id: String?
    @NSManaged public var user: UserManagedObject?

}
