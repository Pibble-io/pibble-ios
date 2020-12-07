//
//  CommentManagedObject+CoreDataProperties.swift
//  
//
//  Created by Sergey Kazakov on 05/10/2019.
//
//

import Foundation
import CoreData


extension CommentManagedObject {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CommentManagedObject> {
        return NSFetchRequest<CommentManagedObject>(entityName: "Comment")
    }

    @NSManaged public var body: String?
    @NSManaged public var createdAt: NSDate?
    @NSManaged public var id: Int32
    @NSManaged public var isCurentUserComment: Bool
    @NSManaged public var isDraft: Bool
    @NSManaged public var isLocallyDeletedComment: Bool
    @NSManaged public var isReply: Bool
    @NSManaged public var rootParentCommentId: Int32
    @NSManaged public var shouldTriggerUpdate: Bool
    @NSManaged public var updatedAt: NSDate?
    @NSManaged public var upVoted: Bool
    @NSManaged public var upVotesAmount: Int32
    @NSManaged public var uuid: String?
    @NSManaged public var inPreviewOfPosting: PostingManagedObject?
    @NSManaged public var parentComment: CommentManagedObject?
    @NSManaged public var posting: PostingManagedObject?
    @NSManaged public var previewParentComment: CommentManagedObject?
    @NSManaged public var previewReplies: NSSet?
    @NSManaged public var replies: NSSet?
    @NSManaged public var user: UserManagedObject?

}

// MARK: Generated accessors for previewReplies
extension CommentManagedObject {

    @objc(addPreviewRepliesObject:)
    @NSManaged public func addToPreviewReplies(_ value: CommentManagedObject)

    @objc(removePreviewRepliesObject:)
    @NSManaged public func removeFromPreviewReplies(_ value: CommentManagedObject)

    @objc(addPreviewReplies:)
    @NSManaged public func addToPreviewReplies(_ values: NSSet)

    @objc(removePreviewReplies:)
    @NSManaged public func removeFromPreviewReplies(_ values: NSSet)

}

// MARK: Generated accessors for replies
extension CommentManagedObject {

    @objc(addRepliesObject:)
    @NSManaged public func addToReplies(_ value: CommentManagedObject)

    @objc(removeRepliesObject:)
    @NSManaged public func removeFromReplies(_ value: CommentManagedObject)

    @objc(addReplies:)
    @NSManaged public func addToReplies(_ values: NSSet)

    @objc(removeReplies:)
    @NSManaged public func removeFromReplies(_ values: NSSet)

}
