//
//  PostHelpAnswerManagedObject+CoreDataProperties.swift
//  
//
//  Created by Sergey Kazakov on 05/10/2019.
//
//

import Foundation
import CoreData


extension PostHelpAnswerManagedObject {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PostHelpAnswerManagedObject> {
        return NSFetchRequest<PostHelpAnswerManagedObject>(entityName: "PostHelpAnswer")
    }

    @NSManaged public var body: String?
    @NSManaged public var createdAt: NSDate?
    @NSManaged public var id: Int32
    @NSManaged public var isCurentUserComment: Bool
    @NSManaged public var isDraft: Bool
    @NSManaged public var isLocallyDeletedComment: Bool
    @NSManaged public var isPicked: Bool
    @NSManaged public var isReply: Bool
    @NSManaged public var rootParentCommentId: Int32
    @NSManaged public var shouldTriggerUpdate: Bool
    @NSManaged public var updatedAt: NSDate?
    @NSManaged public var upVoted: Bool
    @NSManaged public var upVotesAmount: Int32
    @NSManaged public var uuid: String?
    @NSManaged public var parentAnswer: PostHelpAnswerManagedObject?
    @NSManaged public var postHelpRequest: PostHelpRequestManagedObject?
    @NSManaged public var replies: NSSet?
    @NSManaged public var user: UserManagedObject?

}

// MARK: Generated accessors for replies
extension PostHelpAnswerManagedObject {

    @objc(addRepliesObject:)
    @NSManaged public func addToReplies(_ value: PostHelpAnswerManagedObject)

    @objc(removeRepliesObject:)
    @NSManaged public func removeFromReplies(_ value: PostHelpAnswerManagedObject)

    @objc(addReplies:)
    @NSManaged public func addToReplies(_ values: NSSet)

    @objc(removeReplies:)
    @NSManaged public func removeFromReplies(_ values: NSSet)

}
