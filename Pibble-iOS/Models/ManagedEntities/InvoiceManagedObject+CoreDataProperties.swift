//
//  InvoiceManagedObject+CoreDataProperties.swift
//  
//
//  Created by Sergey Kazakov on 05/10/2019.
//
//

import Foundation
import CoreData


extension InvoiceManagedObject {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<InvoiceManagedObject> {
        return NSFetchRequest<InvoiceManagedObject>(entityName: "Invoice")
    }

    @NSManaged public var activityDescription: String?
    @NSManaged public var activityStatus: String?
    @NSManaged public var value: NSDecimalNumber?
    @NSManaged public var chatRoom: ChatRoomManagedObject?
    @NSManaged public var currentUserInvoiceDigitalGoodPost: PostingManagedObject?
    @NSManaged public var fromUser: UserManagedObject?
    @NSManaged public var postChatMessages: NSSet?
    @NSManaged public var toUser: UserManagedObject?

}

// MARK: Generated accessors for postChatMessages
extension InvoiceManagedObject {

    @objc(addPostChatMessagesObject:)
    @NSManaged public func addToPostChatMessages(_ value: PostChatMessageManagedObject)

    @objc(removePostChatMessagesObject:)
    @NSManaged public func removeFromPostChatMessages(_ value: PostChatMessageManagedObject)

    @objc(addPostChatMessages:)
    @NSManaged public func addToPostChatMessages(_ values: NSSet)

    @objc(removePostChatMessages:)
    @NSManaged public func removeFromPostChatMessages(_ values: NSSet)

}
