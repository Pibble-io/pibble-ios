//
//  WalletActivityProtocol+StorageExtensions.swift
//  Pibble
//
//  Created by Kazakov Sergey on 25.08.2018.
//  Copyright © 2018 com.kazai. All rights reserved.
//

import Foundation
import CoreData

extension WalletActivityManagedObject {
  var walletActivityEntity: WalletActivityEntity {
    switch walletActivityType {
    case .internalTransaction:
      return WalletActivityEntity(entity: self as! InternalTransactionManagedObject)
    case .externalTransaction:
      return WalletActivityEntity(entity: self as! ExternalTransactionManagedObject)
    case .invoice:
      return WalletActivityEntity(entity: self as! InvoiceManagedObject)
    case .reward:
      return WalletActivityEntity(entity: self as! RewardTransactionManagedObject)
    case .exchange:
      return WalletActivityEntity(entity: self as! ExchangeTransactionManagedObject)
    case .promotionTransaction:
      return WalletActivityEntity(entity: self as! PromotionTransactionManagedObject)
    case .externalExchange:
      return WalletActivityEntity(entity: self as! ExternalExchangeTransactionManagedObject)
    case .commerceTransaction:
      return WalletActivityEntity(entity: self as! CommerceTransactionManagedObject)
    case .digitalGoodTransaction:
      return WalletActivityEntity(entity: self as! DigitalGoodTransactionManagedObject)
    case .airdropTransaction:
      return WalletActivityEntity(entity: self as! AirdropTransactionManagedObject)
    case .goodTransaction:
      return WalletActivityEntity(entity: self as! GoodTransactionManagedObject)
    case .funding:
      return WalletActivityEntity(entity: self as! FundingTransactionManagedObject) //old funding transactions
    case .charityFundingDonateTransaction:
      return WalletActivityEntity(entity: self as! CharityFundingDonateTransactionManagedObject)
    case .crowdFundingDonateTransaction:
      return WalletActivityEntity(entity: self as! CrowdFundingDonateTransactionManagedObject)
    case .crowdFundingWithRewardsDonateTransaction:
      return WalletActivityEntity(entity: self as! CrowdFundingWithRewardsDonateTransactionManagedObject)
    case .charityFundingRefundTransaction:
      return WalletActivityEntity(entity: self as! CharityFundingRefundTransactionManagedObject)
    case .crowdFundingRefundTransaction:
      return WalletActivityEntity(entity: self as! CrowdFundingRefundTransactionManagedObject)
    case .crowdFundingWithRewardsRefundTransaction:
      return WalletActivityEntity(entity: self as! CrowdFundingWithRewardsRefundTransactionManagedObject)
    case .charityFundingResultTransaction:
      return WalletActivityEntity(entity: self as! CharityFundingResultTransactionManagedObject)
    case .crowdFundingResultTransaction:
      return WalletActivityEntity(entity: self as! CrowdFundingResultTransactionManagedObject)
    case .crowdFundingWithRewardsResultTransaction:
      return WalletActivityEntity(entity: self as! CrowdFundingWithRewardsResultTransactionManagedObject)
    case .postHelpPaymentTransaction:
       return WalletActivityEntity(entity: self as! PostHelpPaymentTransactionManagedObject)
    case .postHelpRewardTransaction:
      return WalletActivityEntity(entity: self as! PostHelpRewardTransactionManagedObject)
    }
  }
}

extension WalletActivityManagedObject: WalletActivityProtocol {
  var walletActivityType: WalletActivityType {
    return WalletActivityType(rawValue: activityType ?? "")!
  }
  
  var activityCreatedAt: String {
    return createdAt ?? ""
  }
 
  var identifier: Int {
    return Int(id)
  }
}
