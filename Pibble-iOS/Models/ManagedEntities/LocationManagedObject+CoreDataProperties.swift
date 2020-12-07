//
//  LocationManagedObject+CoreDataProperties.swift
//  
//
//  Created by Sergey Kazakov on 05/10/2019.
//
//

import Foundation
import CoreData


extension LocationManagedObject {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<LocationManagedObject> {
        return NSFetchRequest<LocationManagedObject>(entityName: "Location")
    }

    @NSManaged public var id: Int32
    @NSManaged public var latitude: String?
    @NSManaged public var longitude: String?
    @NSManaged public var placeDescription: String?
    @NSManaged public var placeId: String?
    @NSManaged public var posted: Int32
    @NSManaged public var mediaPostings: NSSet?
    @NSManaged public var searchResults: NSSet?

}

// MARK: Generated accessors for mediaPostings
extension LocationManagedObject {

    @objc(addMediaPostingsObject:)
    @NSManaged public func addToMediaPostings(_ value: PostingManagedObject)

    @objc(removeMediaPostingsObject:)
    @NSManaged public func removeFromMediaPostings(_ value: PostingManagedObject)

    @objc(addMediaPostings:)
    @NSManaged public func addToMediaPostings(_ values: NSSet)

    @objc(removeMediaPostings:)
    @NSManaged public func removeFromMediaPostings(_ values: NSSet)

}

// MARK: Generated accessors for searchResults
extension LocationManagedObject {

    @objc(addSearchResultsObject:)
    @NSManaged public func addToSearchResults(_ value: LocationSearchResultManagedObject)

    @objc(removeSearchResultsObject:)
    @NSManaged public func removeFromSearchResults(_ value: LocationSearchResultManagedObject)

    @objc(addSearchResults:)
    @NSManaged public func addToSearchResults(_ values: NSSet)

    @objc(removeSearchResults:)
    @NSManaged public func removeFromSearchResults(_ values: NSSet)

}
