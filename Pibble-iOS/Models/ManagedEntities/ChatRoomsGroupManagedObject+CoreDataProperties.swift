//
//  ChatRoomsGroupManagedObject+CoreDataProperties.swift
//  
//
//  Created by Sergey Kazakov on 05/10/2019.
//
//

import Foundation
import CoreData


extension ChatRoomsGroupManagedObject {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ChatRoomsGroupManagedObject> {
        return NSFetchRequest<ChatRoomsGroupManagedObject>(entityName: "ChatRoomsGroup")
    }

    @NSManaged public var createdAt: NSDate?
    @NSManaged public var id: Int32
    @NSManaged public var lastMessageCreatedAt: NSDate?
    @NSManaged public var roomsCount: Int32
    @NSManaged public var unreadMessageCount: Int32
    @NSManaged public var updatedAt: NSDate?
    @NSManaged public var lastMessage: BaseChatMessageManagedObject?
    @NSManaged public var post: PostingManagedObject?
    @NSManaged public var rooms: NSSet?
    @NSManaged public var user: UserManagedObject?

}

// MARK: Generated accessors for rooms
extension ChatRoomsGroupManagedObject {

    @objc(addRoomsObject:)
    @NSManaged public func addToRooms(_ value: ChatRoomManagedObject)

    @objc(removeRoomsObject:)
    @NSManaged public func removeFromRooms(_ value: ChatRoomManagedObject)

    @objc(addRooms:)
    @NSManaged public func addToRooms(_ values: NSSet)

    @objc(removeRooms:)
    @NSManaged public func removeFromRooms(_ values: NSSet)

}
