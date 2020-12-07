//
//  Campaign+StorageExtensions.swift
//  Pibble
//
//  Created by Kazakov Sergey on 29.10.2018.
//  Copyright © 2018 com.kazai. All rights reserved.
//

import Foundation
import CoreData

extension FundingCampaignManagedObject: MappableManagedObject {
  typealias ID = String?
  
  fileprivate func update(with object: FundingCampaignProtocol, in context: NSManagedObjectContext) -> Self {
    id = object.identifier
    title = object.campaignTitle
    goalAmount = NSDecimalNumber(value: object.campaignGoalAmount)
    collectedAmount = NSDecimalNumber(value: object.campaignCollectedAmount)
    raisingFor = object.campaignRaisingFor.rawValue
    startDate = object.campaignStartDate.toNSDate
    endDate = object.campaignEndDate.toNSDate
    tags = object.campaignTags
    donatorsCount = Int32(object.campaignDonatorsCount)
    status = object.campaignStatus.rawValue
    ownerId = Int32(object.campaignOwnerIdentifier)
    
    if let rewards = object.campaignRewards {
      hasRewards = true
      activeRewardType = rewards.activeReward.rawValue
      
      rewardRegularPrice = NSDecimalNumber(value: rewards.regularReward.rewardPrice)
      rewardEarlyBirdPrice = NSDecimalNumber(value: rewards.earlyBirdReward.rewardPrice)
      rewardDiscountPrice = NSDecimalNumber(value: rewards.discountReward.rewardPrice)
      
      rewardEarlyBirdAmount = rewards.earlyBirdReward.rewardAmount.map { Int32($0) } ?? 0
      rewardDiscountAmount = rewards.discountReward.rewardAmount.map { Int32($0) } ?? 0
      
      rewardEarlyBirdLeftAmount = rewards.earlyBirdReward.rewardsLeftAmount.map { Int32($0) } ?? 0
      rewardDiscountLeftAmount = rewards.discountReward.rewardsLeftAmount.map { Int32($0) } ?? 0
    } else {
      hasRewards = false
    }
    return self
  }
  
  static func replaceOrCreate(with object: FundingCampaignProtocol, in context: NSManagedObjectContext) -> FundingCampaignManagedObject {
    
    let managedObject = FundingCampaignManagedObject.findOrCreate(with: FundingCampaignManagedObject.ID(object.identifier), in: context)
    return managedObject.update(with: object, in: context)
  }
}

fileprivate struct FundingReward: FundingRewardProtocol {
  let rewardSoldAmount: Int
  let rewardPrice: Double
  let rewardAmount: Int?
  let rewardsLeftAmount: Int?
  let isRewardActive: Bool
}

fileprivate struct FundingCampaignRewards: FundingCampaignRewardsProtocol {
  let regularReward: FundingRewardProtocol
  let earlyBirdReward: FundingRewardProtocol
  let discountReward: FundingRewardProtocol
}

extension FundingCampaignManagedObject: FundingCampaignProtocol {
  var campaignOwnerIdentifier: Int {
    return Int(ownerId)
  }
  
  var campaignStatus: FundingCampaignStatus {
    return FundingCampaignStatus(rawValue: status ?? "")
  }
  
  var campaignDonatorsCount: Int {
    return Int(donatorsCount)
  }
  
  var campaignRewards: FundingCampaignRewardsProtocol? {
    guard hasRewards else {
      return nil
    }
    
    guard let activeReward = FundingCampaignRewardsType(rawValue: activeRewardType ?? "") else {
      return nil
    }
    
    let earlyBird = FundingReward(rewardSoldAmount: Int(rewardEarlyBirdSoldAmount), rewardPrice: rewardEarlyBirdPrice?.doubleValue ?? 0.0,
                                  rewardAmount: Int(rewardEarlyBirdAmount),
                                  rewardsLeftAmount: Int(rewardEarlyBirdLeftAmount),
                                  isRewardActive: activeReward == .earlyBird)
    
    let discount = FundingReward(rewardSoldAmount: Int(rewardDiscountSoldAmount),
                                 rewardPrice: rewardDiscountPrice?.doubleValue ?? 0.0,
                                 rewardAmount: Int(rewardDiscountAmount),
                                 rewardsLeftAmount: Int(rewardDiscountLeftAmount),
                                 isRewardActive: activeReward == .discount)

    let regular = FundingReward(rewardSoldAmount: Int(rewardRegularSoldAmount),
                                rewardPrice: rewardRegularPrice?.doubleValue ?? 0.0,
                                rewardAmount: nil,
                                rewardsLeftAmount: nil,
                                isRewardActive: activeReward == .regular)
    
    return FundingCampaignRewards(regularReward: regular,
                                  earlyBirdReward: earlyBird,
                                  discountReward: discount)
  }
  
  var identifier: String {
    return id ?? ""
  }
  
  var campaignTags: String {
    return tags ?? ""
  }
  
  var campaignRaisingFor: FundRaiseRecipient {
    return FundRaiseRecipient(rawValue: raisingFor ?? "") ?? .charity
  }
  
  var campaignTeam: FundingCampaignTeamProtocol? {
    return team
  }
  
  var campaignTitle: String {
    return title ?? ""
  }
  
  var campaignGoalAmount: Double {
    return goalAmount?.doubleValue ?? 0.0
  }
  
  var campaignCollectedAmount: Double {
    return collectedAmount?.doubleValue ?? 0.0
  }
  
  var campaignStartDate: Date {
    return startDate?.toDate ?? Date(timeIntervalSince1970: 0.0)
  }
  
  var campaignEndDate: Date {
    return endDate?.toDate ?? Date(timeIntervalSince1970: 0.0)
  }
}

extension FundingCampaignProtocol {
  func updateOrCreateManagedObject(in context: NSManagedObjectContext) {
    let _ = FundingCampaignManagedObject.replaceOrCreate(with: self, in: context)
  }
  
  func delete(in context: NSManagedObjectContext) {
    let managedObject = FundingCampaignManagedObject.replaceOrCreate(with: self, in: context)
    context.delete(managedObject)
  }
}
