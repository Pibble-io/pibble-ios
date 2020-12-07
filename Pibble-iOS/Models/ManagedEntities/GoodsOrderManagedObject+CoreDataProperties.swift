//
//  GoodsOrderManagedObject+CoreDataProperties.swift
//  
//
//  Created by Sergey Kazakov on 05/10/2019.
//
//

import Foundation
import CoreData


extension GoodsOrderManagedObject {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<GoodsOrderManagedObject> {
        return NSFetchRequest<GoodsOrderManagedObject>(entityName: "GoodsOrder")
    }

    @NSManaged public var createdAt: NSDate?
    @NSManaged public var id: Int32
    @NSManaged public var price: NSDecimalNumber?
    @NSManaged public var status: String?
    @NSManaged public var updatedAt: NSDate?
    @NSManaged public var uuid: String?
    @NSManaged public var chatRoom: ChatRoomManagedObject?
    @NSManaged public var chatSystemMessage: NSSet?

}

// MARK: Generated accessors for chatSystemMessage
extension GoodsOrderManagedObject {

    @objc(addChatSystemMessageObject:)
    @NSManaged public func addToChatSystemMessage(_ value: ChatSystemMessageManagedObject)

    @objc(removeChatSystemMessageObject:)
    @NSManaged public func removeFromChatSystemMessage(_ value: ChatSystemMessageManagedObject)

    @objc(addChatSystemMessage:)
    @NSManaged public func addToChatSystemMessage(_ values: NSSet)

    @objc(removeChatSystemMessage:)
    @NSManaged public func removeFromChatSystemMessage(_ values: NSSet)

}
