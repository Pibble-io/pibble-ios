//
//  PostHelpRequestManagedObject+CoreDataProperties.swift
//  
//
//  Created by Sergey Kazakov on 05/10/2019.
//
//

import Foundation
import CoreData


extension PostHelpRequestManagedObject {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PostHelpRequestManagedObject> {
        return NSFetchRequest<PostHelpRequestManagedObject>(entityName: "PostHelpRequest")
    }

    @NSManaged public var createdAt: NSDate?
    @NSManaged public var descriptionText: String?
    @NSManaged public var id: Int32
    @NSManaged public var isClosed: Bool
    @NSManaged public var reward: NSDecimalNumber?
    @NSManaged public var updatedAt: NSDate?
    @NSManaged public var answers: NSSet?
    @NSManaged public var post: PostingManagedObject?
    @NSManaged public var user: UserManagedObject?

}

// MARK: Generated accessors for answers
extension PostHelpRequestManagedObject {

    @objc(addAnswersObject:)
    @NSManaged public func addToAnswers(_ value: PostHelpAnswerManagedObject)

    @objc(removeAnswersObject:)
    @NSManaged public func removeFromAnswers(_ value: PostHelpAnswerManagedObject)

    @objc(addAnswers:)
    @NSManaged public func addToAnswers(_ values: NSSet)

    @objc(removeAnswers:)
    @NSManaged public func removeFromAnswers(_ values: NSSet)

}
