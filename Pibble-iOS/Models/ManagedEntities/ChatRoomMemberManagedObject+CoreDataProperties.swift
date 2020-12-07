//
//  ChatRoomMemberManagedObject+CoreDataProperties.swift
//  
//
//  Created by Sergey Kazakov on 05/10/2019.
//
//

import Foundation
import CoreData


extension ChatRoomMemberManagedObject {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ChatRoomMemberManagedObject> {
        return NSFetchRequest<ChatRoomMemberManagedObject>(entityName: "ChatRoomMember")
    }

    @NSManaged public var deletedAt: String?
    @NSManaged public var id: String?
    @NSManaged public var chat: ChatRoomManagedObject?
    @NSManaged public var user: UserManagedObject?

}
