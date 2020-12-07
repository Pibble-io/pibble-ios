//
//  NotificationManagedObject+CoreDataProperties.swift
//  
//
//  Created by Sergey Kazakov on 05/10/2019.
//
//

import Foundation
import CoreData


extension NotificationManagedObject {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<NotificationManagedObject> {
        return NSFetchRequest<NotificationManagedObject>(entityName: "Notification")
    }

    @NSManaged public var createdAt: NSDate?
    @NSManaged public var createdAtDateComponent: NSDate?
    @NSManaged public var id: Int32
    @NSManaged public var lastTriggeredUpdateDate: NSDate?
    @NSManaged public var message: String?
    @NSManaged public var type: String?
    @NSManaged public var feedUser: UserManagedObject?
    @NSManaged public var fromUser: UserManagedObject?
    @NSManaged public var relatedPost: PostingManagedObject?
    @NSManaged public var relatedUser: UserManagedObject?
    @NSManaged public var toUser: UserManagedObject?

}
