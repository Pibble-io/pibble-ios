//
//  UserSearchResultManagedObject+CoreDataProperties.swift
//  
//
//  Created by Sergey Kazakov on 05/10/2019.
//
//

import Foundation
import CoreData


extension UserSearchResultManagedObject {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UserSearchResultManagedObject> {
        return NSFetchRequest<UserSearchResultManagedObject>(entityName: "UserSearchResult")
    }

    @NSManaged public var relatedUser: UserManagedObject?

}
