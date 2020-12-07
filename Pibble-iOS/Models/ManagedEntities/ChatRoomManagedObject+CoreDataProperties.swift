//
//  ChatRoomManagedObject+CoreDataProperties.swift
//  
//
//  Created by Sergey Kazakov on 05/10/2019.
//
//

import Foundation
import CoreData


extension ChatRoomManagedObject {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ChatRoomManagedObject> {
        return NSFetchRequest<ChatRoomManagedObject>(entityName: "ChatRoom")
    }

    @NSManaged public var id: Int32
    @NSManaged public var isLeft: Bool
    @NSManaged public var isMuted: Bool
    @NSManaged public var lastMessageCreatedAt: NSDate?
    @NSManaged public var lastTriggeredUpdateDate: NSDate?
    @NSManaged public var type: String?
    @NSManaged public var unreadMessageCount: Int32
    @NSManaged public var chatRoomsGroup: ChatRoomsGroupManagedObject?
    @NSManaged public var lastDigitalGoodInvoice: InvoiceManagedObject?
    @NSManaged public var lastMessage: BaseChatMessageManagedObject?
    @NSManaged public var lastRelatedGoodsOrder: GoodsOrderManagedObject?
    @NSManaged public var members: NSSet?
    @NSManaged public var messages: NSSet?
    @NSManaged public var post: PostingManagedObject?

}

// MARK: Generated accessors for members
extension ChatRoomManagedObject {

    @objc(addMembersObject:)
    @NSManaged public func addToMembers(_ value: ChatRoomMemberManagedObject)

    @objc(removeMembersObject:)
    @NSManaged public func removeFromMembers(_ value: ChatRoomMemberManagedObject)

    @objc(addMembers:)
    @NSManaged public func addToMembers(_ values: NSSet)

    @objc(removeMembers:)
    @NSManaged public func removeFromMembers(_ values: NSSet)

}

// MARK: Generated accessors for messages
extension ChatRoomManagedObject {

    @objc(addMessagesObject:)
    @NSManaged public func addToMessages(_ value: BaseChatMessageManagedObject)

    @objc(removeMessagesObject:)
    @NSManaged public func removeFromMessages(_ value: BaseChatMessageManagedObject)

    @objc(addMessages:)
    @NSManaged public func addToMessages(_ values: NSSet)

    @objc(removeMessages:)
    @NSManaged public func removeFromMessages(_ values: NSSet)

}
