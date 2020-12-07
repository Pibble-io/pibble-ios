//
//  UpvoteManagedObject+CoreDataProperties.swift
//  
//
//  Created by Sergey Kazakov on 05/10/2019.
//
//

import Foundation
import CoreData


extension UpvoteManagedObject {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UpvoteManagedObject> {
        return NSFetchRequest<UpvoteManagedObject>(entityName: "Upvote")
    }

    @NSManaged public var amount: Int32
    @NSManaged public var id: Int32
    @NSManaged public var lastTriggeredUpdateDate: NSDate?
    @NSManaged public var upvoteBackAmount: Int32
    @NSManaged public var fromUser: UserManagedObject?
    @NSManaged public var posting: PostingManagedObject?

}
