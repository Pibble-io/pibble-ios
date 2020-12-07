//
//  FundingCampaignManagedObject+CoreDataProperties.swift
//  
//
//  Created by Sergey Kazakov on 05/10/2019.
//
//

import Foundation
import CoreData


extension FundingCampaignManagedObject {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FundingCampaignManagedObject> {
        return NSFetchRequest<FundingCampaignManagedObject>(entityName: "FundingCampaign")
    }

    @NSManaged public var activeRewardType: String?
    @NSManaged public var collectedAmount: NSDecimalNumber?
    @NSManaged public var donatorsCount: Int32
    @NSManaged public var endDate: NSDate?
    @NSManaged public var goalAmount: NSDecimalNumber?
    @NSManaged public var hasRewards: Bool
    @NSManaged public var id: String?
    @NSManaged public var membersCount: Int32
    @NSManaged public var ownerId: Int32
    @NSManaged public var raisingFor: String?
    @NSManaged public var rewardDiscountAmount: Int32
    @NSManaged public var rewardDiscountLeftAmount: Int32
    @NSManaged public var rewardDiscountPrice: NSDecimalNumber?
    @NSManaged public var rewardDiscountSoldAmount: Int32
    @NSManaged public var rewardEarlyBirdAmount: Int32
    @NSManaged public var rewardEarlyBirdLeftAmount: Int32
    @NSManaged public var rewardEarlyBirdPrice: NSDecimalNumber?
    @NSManaged public var rewardEarlyBirdSoldAmount: Int32
    @NSManaged public var rewardRegularPrice: NSDecimalNumber?
    @NSManaged public var rewardRegularSoldAmount: Int32
    @NSManaged public var startDate: NSDate?
    @NSManaged public var status: String?
    @NSManaged public var tags: String?
    @NSManaged public var title: String?
    @NSManaged public var postings: NSSet?
    @NSManaged public var team: FundingCampaignTeamManagedObject?

}

// MARK: Generated accessors for postings
extension FundingCampaignManagedObject {

    @objc(addPostingsObject:)
    @NSManaged public func addToPostings(_ value: PostingManagedObject)

    @objc(removePostingsObject:)
    @NSManaged public func removeFromPostings(_ value: PostingManagedObject)

    @objc(addPostings:)
    @NSManaged public func addToPostings(_ values: NSSet)

    @objc(removePostings:)
    @NSManaged public func removeFromPostings(_ values: NSSet)

}
