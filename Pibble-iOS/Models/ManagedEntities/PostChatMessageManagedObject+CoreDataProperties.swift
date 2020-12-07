//
//  PostChatMessageManagedObject+CoreDataProperties.swift
//  
//
//  Created by Sergey Kazakov on 05/10/2019.
//
//

import Foundation
import CoreData


extension PostChatMessageManagedObject {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PostChatMessageManagedObject> {
        return NSFetchRequest<PostChatMessageManagedObject>(entityName: "PostChatMessage")
    }

    @NSManaged public var invoice: InvoiceManagedObject?
    @NSManaged public var post: PostingManagedObject?

}
