//
//  ChatSystemMessageManagedObject+CoreDataProperties.swift
//  
//
//  Created by Sergey Kazakov on 05/10/2019.
//
//

import Foundation
import CoreData


extension ChatSystemMessageManagedObject {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ChatSystemMessageManagedObject> {
        return NSFetchRequest<ChatSystemMessageManagedObject>(entityName: "ChatSystemMessage")
    }

    @NSManaged public var systemMessageType: String?
    @NSManaged public var text: String?
    @NSManaged public var goodsOrder: GoodsOrderManagedObject?

}
