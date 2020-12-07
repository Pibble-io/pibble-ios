//
//  TextChatMessageManagedObject+CoreDataProperties.swift
//  
//
//  Created by Sergey Kazakov on 05/10/2019.
//
//

import Foundation
import CoreData


extension TextChatMessageManagedObject {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TextChatMessageManagedObject> {
        return NSFetchRequest<TextChatMessageManagedObject>(entityName: "TextChatMessage")
    }

    @NSManaged public var text: String?

}
