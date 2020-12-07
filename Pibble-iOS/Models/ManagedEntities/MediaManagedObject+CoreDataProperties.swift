//
//  MediaManagedObject+CoreDataProperties.swift
//  
//
//  Created by Sergey Kazakov on 05/10/2019.
//
//

import Foundation
import CoreData


extension MediaManagedObject {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MediaManagedObject> {
        return NSFetchRequest<MediaManagedObject>(entityName: "Media")
    }

    @NSManaged public var height: Double
    @NSManaged public var id: Int64
    @NSManaged public var originalHeight: Double
    @NSManaged public var originalUrlString: String?
    @NSManaged public var originalWidth: Double
    @NSManaged public var passedVerification: Bool
    @NSManaged public var posterUrlString: String?
    @NSManaged public var s3Id: String?
    @NSManaged public var shouldPassVerification: Bool
    @NSManaged public var sortId: Int32
    @NSManaged public var thumbnailUrlString: String?
    @NSManaged public var type: String?
    @NSManaged public var urlString: String?
    @NSManaged public var width: Double
    @NSManaged public var posting: PostingManagedObject?

}
