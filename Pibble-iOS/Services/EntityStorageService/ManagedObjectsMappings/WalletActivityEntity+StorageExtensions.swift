//
//  BaseWalletActivity+StorageExtensions.swift
//  Pibble
//
//  Created by Kazakov Sergey on 25.09.2018.
//  Copyright © 2018 com.kazai. All rights reserved.
//

import Foundation
import CoreData

extension WalletActivityEntity: CoreDataStorableEntity {
  func updateOrCreateManagedObject(in context: NSManagedObjectContext) {
    switch self {
    case .internalTransaction(let entity):
      let _ = InternalTransactionManagedObject.replaceOrCreate(with: entity, in: context)
    case .externalTransaction(let entity):
      let _ = ExternalTransactionManagedObject.replaceOrCreate(with: entity, in: context)
    case .invoice(let entity):
      let _ = InvoiceManagedObject.replaceOrCreate(with: entity, in: context)
    case .rewardTransaction(let entity):
      let _ = RewardTransactionManagedObject.replaceOrCreate(with: entity, in: context)
    case .exchangeTransaction(let entity):
      let _ = ExchangeTransactionManagedObject.replaceOrCreate(with: entity, in: context)
    case .fundingTransaction(let entity):
      let _ = FundingTransactionManagedObject.replaceOrCreate(with: entity, in: context)
    case .promotionTransaction(let entity):
      let  _ = PromotionTransactionManagedObject.replaceOrCreate(with: entity, in: context)
    case .externalExchangeTransaction(let entity):
      let  _ = ExternalExchangeTransactionManagedObject.replaceOrCreate(with: entity, in: context)
    case .commerceTransaction(let entity):
      let  _ = CommerceTransactionManagedObject.replaceOrCreate(with: entity, in: context)
    case .digitalGoodTransaction(let entity):
      let  _ = DigitalGoodTransactionManagedObject.replaceOrCreate(with: entity, in: context)
    case .airdropTransaction(let entity):
      let _ = AirdropTransactionManagedObject.replaceOrCreate(with: entity, in: context)
    case .goodTransaction(let entity):
      let  _ = GoodTransactionManagedObject.replaceOrCreate(with: entity, in: context)
    
    case .charityFundingDonateTransaction(let entity):
      let  _ = CharityFundingDonateTransactionManagedObject.replaceOrCreate(with: entity, in: context)
    case .crowdFundingDonateTransaction(let entity):
      let  _ = CrowdFundingDonateTransactionManagedObject.replaceOrCreate(with: entity, in: context)
    case .crowdFundingWithRewardsDonateTransaction(let entity):
      let  _ = CrowdFundingWithRewardsDonateTransactionManagedObject.replaceOrCreate(with: entity, in: context)
    case .charityFundingRefundTransaction(let entity):
      let  _ = CharityFundingRefundTransactionManagedObject.replaceOrCreate(with: entity, in: context)
    case .crowdFundingRefundTransaction(let entity):
      let  _ = CrowdFundingRefundTransactionManagedObject.replaceOrCreate(with: entity, in: context)
    case .crowdFundingWithRewardsRefundTransaction(let entity):
      let  _ = CrowdFundingWithRewardsRefundTransactionManagedObject.replaceOrCreate(with: entity, in: context)
    case .charityFundingResultTransaction(let entity):
      let  _ = CharityFundingResultTransactionManagedObject.replaceOrCreate(with: entity, in: context)
    case .crowdFundingResultTransaction(let entity):
      let  _ = CrowdFundingResultTransactionManagedObject.replaceOrCreate(with: entity, in: context)
    case .crowdFundingWithRewardsResultTransaction(let entity):
      let  _ = CrowdFundingWithRewardsResultTransactionManagedObject.replaceOrCreate(with: entity, in: context)
    case .postHelpPaymentTransaction(let entity):
      let _  = PostHelpPaymentTransactionManagedObject.replaceOrCreate(with: entity, in: context)
    case .postHelpRewardTransaction(let entity):
      let _ = PostHelpRewardTransactionManagedObject.replaceOrCreate(with: entity, in: context)
    }
  }
  
  func delete(in context: NSManagedObjectContext) {
    let managedObject: NSManagedObject
    switch self {
    case .internalTransaction(let entity):
      managedObject = InternalTransactionManagedObject.replaceOrCreate(with: entity, in: context)
    case .externalTransaction(let entity):
      managedObject = ExternalTransactionManagedObject.replaceOrCreate(with: entity, in: context)
    case .invoice(let entity):
      managedObject = InvoiceManagedObject.replaceOrCreate(with: entity, in: context)
    case .rewardTransaction(let entity):
      managedObject = RewardTransactionManagedObject.replaceOrCreate(with: entity, in: context)
    case .exchangeTransaction(let entity):
      managedObject = ExchangeTransactionManagedObject.replaceOrCreate(with: entity, in: context)
    case .fundingTransaction(let entity):
      managedObject = FundingTransactionManagedObject.replaceOrCreate(with: entity, in: context)
    case .promotionTransaction(let entity):
      managedObject = PromotionTransactionManagedObject.replaceOrCreate(with: entity, in: context)
    case .externalExchangeTransaction(let entity):
      managedObject = ExternalExchangeTransactionManagedObject.replaceOrCreate(with: entity, in: context)
    case .commerceTransaction(let entity):
      managedObject = CommerceTransactionManagedObject.replaceOrCreate(with: entity, in: context)
    case .digitalGoodTransaction(let entity):
      managedObject = DigitalGoodTransactionManagedObject.replaceOrCreate(with: entity, in: context)
    case .airdropTransaction(let entity):
      managedObject = AirdropTransactionManagedObject.replaceOrCreate(with: entity, in: context)
    case .goodTransaction(let entity):
      managedObject = GoodTransactionManagedObject.replaceOrCreate(with: entity, in: context)
    
    case .charityFundingDonateTransaction(let entity):
      managedObject = CharityFundingDonateTransactionManagedObject.replaceOrCreate(with: entity, in: context)
    case .crowdFundingDonateTransaction(let entity):
      managedObject = CrowdFundingDonateTransactionManagedObject.replaceOrCreate(with: entity, in: context)
    case .crowdFundingWithRewardsDonateTransaction(let entity):
      managedObject = CrowdFundingWithRewardsDonateTransactionManagedObject.replaceOrCreate(with: entity, in: context)
    case .charityFundingRefundTransaction(let entity):
      managedObject = CharityFundingRefundTransactionManagedObject.replaceOrCreate(with: entity, in: context)
    case .crowdFundingRefundTransaction(let entity):
      managedObject = CrowdFundingRefundTransactionManagedObject.replaceOrCreate(with: entity, in: context)
    case .crowdFundingWithRewardsRefundTransaction(let entity):
      managedObject = CrowdFundingWithRewardsRefundTransactionManagedObject.replaceOrCreate(with: entity, in: context)
    case .charityFundingResultTransaction(let entity):
      managedObject = CharityFundingResultTransactionManagedObject.replaceOrCreate(with: entity, in: context)
    case .crowdFundingResultTransaction(let entity):
      managedObject = CrowdFundingResultTransactionManagedObject.replaceOrCreate(with: entity, in: context)
    case .crowdFundingWithRewardsResultTransaction(let entity):
      managedObject = CrowdFundingWithRewardsResultTransactionManagedObject.replaceOrCreate(with: entity, in: context)
    case .postHelpPaymentTransaction(let entity):
      managedObject = PostHelpPaymentTransactionManagedObject.replaceOrCreate(with: entity, in: context)
    case .postHelpRewardTransaction(let entity):
      managedObject = PostHelpRewardTransactionManagedObject.replaceOrCreate(with: entity, in: context)
    }
    
    context.delete(managedObject)
  }
}

enum WalletActivitiesRelations: CoreDataStorableRelation {
  case user(activity: WalletActivityEntity, user: UserProtocol)
  case userActivity(activity: PartialWalletActivityEntity, user: UserProtocol, currencyType: ActivityCurrencyType?)
  
  case postFundingDonationActivities(activity: PartialWalletActivityEntity, post: PostingProtocol)
  
  func updateOrCreateManagedObject(in context: NSManagedObjectContext) {
    switch self {
    case .user(let activity, let user):
      let managedUser = UserManagedObject.replaceOrCreate(with: user, in: context)
      let managedActivity: WalletActivityManagedObject
      
      switch activity {
      case .internalTransaction(let entity):
        managedActivity = InternalTransactionManagedObject.replaceOrCreate(with: entity, in: context)
      case .externalTransaction(let entity):
        managedActivity = ExternalTransactionManagedObject.replaceOrCreate(with: entity, in: context)
      case .invoice(let entity):
        managedActivity = InvoiceManagedObject.replaceOrCreate(with: entity, in: context)
      case .rewardTransaction(let entity):
        managedActivity = RewardTransactionManagedObject.replaceOrCreate(with: entity, in: context)
      case .exchangeTransaction(let entity):
        managedActivity = ExchangeTransactionManagedObject.replaceOrCreate(with: entity, in: context)
      case .fundingTransaction(let entity):
        managedActivity = FundingTransactionManagedObject.replaceOrCreate(with: entity, in: context)
      case .promotionTransaction(let entity):
        managedActivity = PromotionTransactionManagedObject.replaceOrCreate(with: entity, in: context)
      case .externalExchangeTransaction(let entity):
        managedActivity = ExternalExchangeTransactionManagedObject.replaceOrCreate(with: entity, in: context)
      case .commerceTransaction(let entity):
        managedActivity = CommerceTransactionManagedObject.replaceOrCreate(with: entity, in: context)
      case .digitalGoodTransaction(let entity):
        managedActivity = DigitalGoodTransactionManagedObject.replaceOrCreate(with: entity, in: context)
      case .airdropTransaction(let entity):
        managedActivity = AirdropTransactionManagedObject.replaceOrCreate(with: entity, in: context)
      case .goodTransaction(let entity):
        managedActivity = GoodTransactionManagedObject.replaceOrCreate(with: entity, in: context)
        
      case .charityFundingDonateTransaction(let entity):
        managedActivity = CharityFundingDonateTransactionManagedObject.replaceOrCreate(with: entity, in: context)
      case .crowdFundingDonateTransaction(let entity):
        managedActivity = CrowdFundingDonateTransactionManagedObject.replaceOrCreate(with: entity, in: context)
      case .crowdFundingWithRewardsDonateTransaction(let entity):
        managedActivity = CrowdFundingWithRewardsDonateTransactionManagedObject.replaceOrCreate(with: entity, in: context)
      case .charityFundingRefundTransaction(let entity):
        managedActivity = CharityFundingRefundTransactionManagedObject.replaceOrCreate(with: entity, in: context)
      case .crowdFundingRefundTransaction(let entity):
        managedActivity = CrowdFundingRefundTransactionManagedObject.replaceOrCreate(with: entity, in: context)
      case .crowdFundingWithRewardsRefundTransaction(let entity):
        managedActivity = CrowdFundingWithRewardsRefundTransactionManagedObject.replaceOrCreate(with: entity, in: context)
      case .charityFundingResultTransaction(let entity):
        managedActivity = CharityFundingResultTransactionManagedObject.replaceOrCreate(with: entity, in: context)
      case .crowdFundingResultTransaction(let entity):
        managedActivity = CrowdFundingResultTransactionManagedObject.replaceOrCreate(with: entity, in: context)
      case .crowdFundingWithRewardsResultTransaction(let entity):
        managedActivity = CrowdFundingWithRewardsResultTransactionManagedObject.replaceOrCreate(with: entity, in: context)
      case .postHelpPaymentTransaction(let entity):
        managedActivity = PostHelpPaymentTransactionManagedObject.replaceOrCreate(with: entity, in: context)
      case .postHelpRewardTransaction(let entity):
        managedActivity = PostHelpRewardTransactionManagedObject.replaceOrCreate(with: entity, in: context)
      }
      
      managedActivity.user = managedUser
    case .userActivity(let activity, let user, let currencyType):
      let managedUser = UserManagedObject.replaceOrCreate(with: user, in: context)
      let managedActivity: WalletActivityManagedObject
      
      switch activity {
      case .internalTransaction(let entity):
        managedActivity = InternalTransactionManagedObject.updateOrCreate(with: entity, in: context)
      case .externalTransaction(let entity):
        managedActivity = ExternalTransactionManagedObject.updateOrCreate(with: entity, in: context)
      case .invoice(let entity):
        managedActivity = InvoiceManagedObject.updateOrCreate(with: entity, in: context)
      case .rewardTransaction(let entity):
        managedActivity = RewardTransactionManagedObject.updateOrCreate(with: entity, in: context)
      case .exchangeTransaction(let entity):
        managedActivity = ExchangeTransactionManagedObject.updateOrCreate(with: entity, in: context)
      case .fundingTransaction(let entity):
        managedActivity = FundingTransactionManagedObject.updateOrCreate(with: entity, in: context)
      case .promotionTransaction(let entity):
        managedActivity = PromotionTransactionManagedObject.updateOrCreate(with: entity, in: context)
      case .externalExchangeTransaction(let entity):
        managedActivity = ExternalExchangeTransactionManagedObject.updateOrCreate(with: entity, in: context)
      case .commerceTransaction(let entity):
        managedActivity = CommerceTransactionManagedObject.updateOrCreate(with: entity, in: context)
      case .digitalGoodTransaction(let entity):
        managedActivity = DigitalGoodTransactionManagedObject.updateOrCreate(with: entity, in: context)
      case .airdropTransaction(let entity):
        managedActivity = AirdropTransactionManagedObject.updateOrCreate(with: entity, in: context)
      case .goodTransaction(let entity):
        managedActivity = GoodTransactionManagedObject.updateOrCreate(with: entity, in: context)
        
      case .charityFundingDonateTransaction(let entity):
        managedActivity = CharityFundingDonateTransactionManagedObject.updateOrCreate(with: entity, in: context)
      case .crowdFundingDonateTransaction(let entity):
        managedActivity = CrowdFundingDonateTransactionManagedObject.updateOrCreate(with: entity, in: context)
      case .crowdFundingWithRewardsDonateTransaction(let entity):
        managedActivity = CrowdFundingWithRewardsDonateTransactionManagedObject.updateOrCreate(with: entity, in: context)
      case .charityFundingRefundTransaction(let entity):
        managedActivity = CharityFundingRefundTransactionManagedObject.updateOrCreate(with: entity, in: context)
      case .crowdFundingRefundTransaction(let entity):
        managedActivity = CrowdFundingRefundTransactionManagedObject.updateOrCreate(with: entity, in: context)
      case .crowdFundingWithRewardsRefundTransaction(let entity):
        managedActivity = CrowdFundingWithRewardsRefundTransactionManagedObject.updateOrCreate(with: entity, in: context)
      case .charityFundingResultTransaction(let entity):
        managedActivity = CharityFundingResultTransactionManagedObject.updateOrCreate(with: entity, in: context)
      case .crowdFundingResultTransaction(let entity):
        managedActivity = CrowdFundingResultTransactionManagedObject.updateOrCreate(with: entity, in: context)
      case .crowdFundingWithRewardsResultTransaction(let entity):
        managedActivity = CrowdFundingWithRewardsResultTransactionManagedObject.updateOrCreate(with: entity, in: context)
      case .postHelpPaymentTransaction(let entity):
        managedActivity = PostHelpPaymentTransactionManagedObject.updateOrCreate(with: entity, in: context)
      case .postHelpRewardTransaction(let entity):
        managedActivity = PostHelpRewardTransactionManagedObject.updateOrCreate(with: entity, in: context)
      }
      
      managedActivity.user = managedUser
      
      if let currencyType = currencyType {
        switch currencyType {
        case .coin(_):
          managedActivity.isCoinCurrencyType = true
        case .brush:
          managedActivity.isBrushCurrencyType = true
        }
      }
    case .postFundingDonationActivities(let activity, _):
      let managedActivity: WalletActivityManagedObject
      
      switch activity {
      case .internalTransaction(let entity):
        managedActivity = InternalTransactionManagedObject.updateOrCreate(with: entity, in: context)
      case .externalTransaction(let entity):
        managedActivity = ExternalTransactionManagedObject.updateOrCreate(with: entity, in: context)
      case .invoice(let entity):
        managedActivity = InvoiceManagedObject.updateOrCreate(with: entity, in: context)
      case .rewardTransaction(let entity):
        managedActivity = RewardTransactionManagedObject.updateOrCreate(with: entity, in: context)
      case .exchangeTransaction(let entity):
        managedActivity = ExchangeTransactionManagedObject.updateOrCreate(with: entity, in: context)
      case .fundingTransaction(let entity):
        managedActivity = FundingTransactionManagedObject.updateOrCreate(with: entity, in: context)
      case .promotionTransaction(let entity):
        managedActivity = PromotionTransactionManagedObject.updateOrCreate(with: entity, in: context)
      case .externalExchangeTransaction(let entity):
        managedActivity = ExternalExchangeTransactionManagedObject.updateOrCreate(with: entity, in: context)
      case .commerceTransaction(let entity):
        managedActivity = CommerceTransactionManagedObject.updateOrCreate(with: entity, in: context)
      case .digitalGoodTransaction(let entity):
        managedActivity = DigitalGoodTransactionManagedObject.updateOrCreate(with: entity, in: context)
      case .airdropTransaction(let entity):
        managedActivity = AirdropTransactionManagedObject.updateOrCreate(with: entity, in: context)
      case .goodTransaction(let entity):
        managedActivity = GoodTransactionManagedObject.updateOrCreate(with: entity, in: context)
        
      case .charityFundingDonateTransaction(let entity):
        managedActivity = CharityFundingDonateTransactionManagedObject.updateOrCreate(with: entity, in: context)
      case .crowdFundingDonateTransaction(let entity):
        managedActivity = CrowdFundingDonateTransactionManagedObject.updateOrCreate(with: entity, in: context)
      case .crowdFundingWithRewardsDonateTransaction(let entity):
        managedActivity = CrowdFundingWithRewardsDonateTransactionManagedObject.updateOrCreate(with: entity, in: context)
      case .charityFundingRefundTransaction(let entity):
        managedActivity = CharityFundingRefundTransactionManagedObject.updateOrCreate(with: entity, in: context)
      case .crowdFundingRefundTransaction(let entity):
        managedActivity = CrowdFundingRefundTransactionManagedObject.updateOrCreate(with: entity, in: context)
      case .crowdFundingWithRewardsRefundTransaction(let entity):
        managedActivity = CrowdFundingWithRewardsRefundTransactionManagedObject.updateOrCreate(with: entity, in: context)
      case .charityFundingResultTransaction(let entity):
        managedActivity = CharityFundingResultTransactionManagedObject.updateOrCreate(with: entity, in: context)
      case .crowdFundingResultTransaction(let entity):
        managedActivity = CrowdFundingResultTransactionManagedObject.updateOrCreate(with: entity, in: context)
      case .crowdFundingWithRewardsResultTransaction(let entity):
        managedActivity = CrowdFundingWithRewardsResultTransactionManagedObject.updateOrCreate(with: entity, in: context)
      case .postHelpPaymentTransaction(let entity):
        managedActivity = PostHelpPaymentTransactionManagedObject.updateOrCreate(with: entity, in: context)
      case .postHelpRewardTransaction(let entity):
        managedActivity = PostHelpRewardTransactionManagedObject.updateOrCreate(with: entity, in: context)
      }
    }
  }
  
  func delete(in context: NSManagedObjectContext) {
    fatalError("Not implemented")
  }
}

