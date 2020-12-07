//
//  LeaderboardEntryManagedObject+CoreDataProperties.swift
//  
//
//  Created by Sergey Kazakov on 05/10/2019.
//
//

import Foundation
import CoreData


extension LeaderboardEntryManagedObject {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<LeaderboardEntryManagedObject> {
        return NSFetchRequest<LeaderboardEntryManagedObject>(entityName: "LeaderboardEntry")
    }

    @NSManaged public var allHistoryChallenge: Bool
    @NSManaged public var dailyChallenge: Int32
    @NSManaged public var id: String?
    @NSManaged public var isTop: Bool
    @NSManaged public var sortId: Int32
    @NSManaged public var value: NSDecimalNumber?
    @NSManaged public var user: UserManagedObject?

}
