//
//  TagManagedObject+CoreDataProperties.swift
//  
//
//  Created by Sergey Kazakov on 05/10/2019.
//
//

import Foundation
import CoreData


extension TagManagedObject {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TagManagedObject> {
        return NSFetchRequest<TagManagedObject>(entityName: "Tag")
    }

    @NSManaged public var id: Int32
    @NSManaged public var isFollowed: Bool
    @NSManaged public var posted: Int32
    @NSManaged public var tagString: String?
    @NSManaged public var followedBy: NSSet?
    @NSManaged public var posts: NSSet?
    @NSManaged public var relatedTags: NSSet?
    @NSManaged public var searchResults: NSSet?

}

// MARK: Generated accessors for followedBy
extension TagManagedObject {

    @objc(addFollowedByObject:)
    @NSManaged public func addToFollowedBy(_ value: UserManagedObject)

    @objc(removeFollowedByObject:)
    @NSManaged public func removeFromFollowedBy(_ value: UserManagedObject)

    @objc(addFollowedBy:)
    @NSManaged public func addToFollowedBy(_ values: NSSet)

    @objc(removeFollowedBy:)
    @NSManaged public func removeFromFollowedBy(_ values: NSSet)

}

// MARK: Generated accessors for posts
extension TagManagedObject {

    @objc(addPostsObject:)
    @NSManaged public func addToPosts(_ value: PostingManagedObject)

    @objc(removePostsObject:)
    @NSManaged public func removeFromPosts(_ value: PostingManagedObject)

    @objc(addPosts:)
    @NSManaged public func addToPosts(_ values: NSSet)

    @objc(removePosts:)
    @NSManaged public func removeFromPosts(_ values: NSSet)

}

// MARK: Generated accessors for relatedTags
extension TagManagedObject {

    @objc(addRelatedTagsObject:)
    @NSManaged public func addToRelatedTags(_ value: TagManagedObject)

    @objc(removeRelatedTagsObject:)
    @NSManaged public func removeFromRelatedTags(_ value: TagManagedObject)

    @objc(addRelatedTags:)
    @NSManaged public func addToRelatedTags(_ values: NSSet)

    @objc(removeRelatedTags:)
    @NSManaged public func removeFromRelatedTags(_ values: NSSet)

}

// MARK: Generated accessors for searchResults
extension TagManagedObject {

    @objc(addSearchResultsObject:)
    @NSManaged public func addToSearchResults(_ value: TagSearchResultManagedObject)

    @objc(removeSearchResultsObject:)
    @NSManaged public func removeFromSearchResults(_ value: TagSearchResultManagedObject)

    @objc(addSearchResults:)
    @NSManaged public func addToSearchResults(_ values: NSSet)

    @objc(removeSearchResults:)
    @NSManaged public func removeFromSearchResults(_ values: NSSet)

}
