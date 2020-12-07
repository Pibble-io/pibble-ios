//
//  BaseChatMessageManagedObject+CoreDataProperties.swift
//  
//
//  Created by Sergey Kazakov on 05/10/2019.
//
//

import Foundation
import CoreData


extension BaseChatMessageManagedObject {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<BaseChatMessageManagedObject> {
        return NSFetchRequest<BaseChatMessageManagedObject>(entityName: "BaseChatMessage")
    }

    @NSManaged public var createdAt: String?
    @NSManaged public var createdAtDate: NSDate?
    @NSManaged public var dateComponent: NSDate?
    @NSManaged public var id: Int32
    @NSManaged public var messageType: String?
    @NSManaged public var chatRoom: ChatRoomManagedObject?
    @NSManaged public var fromUser: UserManagedObject?

}
