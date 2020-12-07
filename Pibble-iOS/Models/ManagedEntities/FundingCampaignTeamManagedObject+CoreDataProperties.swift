//
//  FundingCampaignTeamManagedObject+CoreDataProperties.swift
//  
//
//  Created by Sergey Kazakov on 05/10/2019.
//
//

import Foundation
import CoreData


extension FundingCampaignTeamManagedObject {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FundingCampaignTeamManagedObject> {
        return NSFetchRequest<FundingCampaignTeamManagedObject>(entityName: "FundingCampaignTeam")
    }

    @NSManaged public var createdAt: NSDate?
    @NSManaged public var fundingType: String?
    @NSManaged public var id: Int32
    @NSManaged public var isSearchResult: Bool
    @NSManaged public var logoUrlString: String?
    @NSManaged public var membersCount: Int32
    @NSManaged public var name: String?
    @NSManaged public var campaign: FundingCampaignManagedObject?
    @NSManaged public var posting: NSSet?
    @NSManaged public var user: UserManagedObject?

}

// MARK: Generated accessors for posting
extension FundingCampaignTeamManagedObject {

    @objc(addPostingObject:)
    @NSManaged public func addToPosting(_ value: PostingManagedObject)

    @objc(removePostingObject:)
    @NSManaged public func removeFromPosting(_ value: PostingManagedObject)

    @objc(addPosting:)
    @NSManaged public func addToPosting(_ values: NSSet)

    @objc(removePosting:)
    @NSManaged public func removeFromPosting(_ values: NSSet)

}
