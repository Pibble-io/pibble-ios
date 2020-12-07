//
//  PromotionPickModuleScope.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 21.08.2018.
//Copyright © 2018 com.kazai. All rights reserved.
//

import Foundation

enum PromotionPick {
  enum PromotionActivities {
    case like
    case share
    case collect
    case tag
    
    static let allCases: [PromotionActivities] = [.like, .share, .collect, .tag]
  }
  
  struct BudgetModel {
    let minBudget: Double
    let maxBudget: Double
    let currency: BalanceCurrency
    let budget: Double
  }
  
  struct BudgetSliderViewModel {
    let minValue: Float
    let maxValue: Float
    let currentValue: Float
  }
  
  struct PromotionReachabilityModel {
    let currency: BalanceCurrency
    let budget: Double
    let reachableUsers: Double
  }
  
  class DraftPromotion: CreatePromotionProtocol {
    var budget: Double = 0.0
    var currency: BalanceCurrency = .pibble
    
    var rewardTypeUpVote: Bool = false
    var rewardTypeShare: Bool = false
    var rewardTypeCollect: Bool = true
    var rewardTypeTag: Bool = false
    
    convenience init(draft: CreatePromotionProtocol) {
      self.init()
      budget = draft.budget
      currency = draft.currency
      rewardTypeUpVote = draft.rewardTypeUpVote
      rewardTypeShare = draft.rewardTypeShare
      rewardTypeCollect = draft.rewardTypeCollect
      rewardTypeTag = draft.rewardTypeTag
    }
  }
  
}
