//
//  PostHelpRewardPickModuleScope.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 05.09.2018.
//Copyright © 2018 com.kazai. All rights reserved.
//

import UIKit

enum PostHelpRewardPick {
  struct PostHelpRewardPickModel {
    let minReward: Double
    let maxReward: Double
    
    let availableInWallet: Double
    let currentPickedAmount: Double
    let currency: BalanceCurrency = .pibble
    
    var isValid: Bool {
      guard currentPickedAmount.isLessThanOrEqualTo(maxReward) else {
        return false
      }
      
      guard currentPickedAmount.isLessThanOrEqualTo(availableInWallet) else {
        return false
      }
      
      guard minReward.isLessThanOrEqualTo(currentPickedAmount) else {
        return false
      }
      
      return true
    }
  }
  
  struct PostHelpRewardPickViewModel {
    let currentPostHelpRewardPickAmount: String
    let currentPostHelpRewardPickCurrency: String
    
    let rewardLimits: String
    let currentBalance: String
    
    let isConfirmButtonEnabled: Bool
    
    init(rewardModel: PostHelpRewardPick.PostHelpRewardPickModel) {
      currentPostHelpRewardPickAmount = String(format: "%.0f", rewardModel.currentPickedAmount)
      currentPostHelpRewardPickCurrency = rewardModel.currency.symbol
      
      let minLimit = "\(String(format: "%.0f", rewardModel.minReward)) \(rewardModel.currency.symbol)"
      let maxLimit = "\(String(format: "%.0f", rewardModel.maxReward)) \(rewardModel.currency.symbol)"
      
      rewardLimits = PostHelpRewardPick.Strings.limits.localize(values: [minLimit, maxLimit])
      
      let balanceValue = "\(String(format: "%.0f", rewardModel.availableInWallet)) \(rewardModel.currency.symbol)"
      currentBalance = PostHelpRewardPick.Strings.balance.localize(values: [rewardModel.currency.symbol, balanceValue])
      
      isConfirmButtonEnabled = rewardModel.isValid
    }    
  }
}

extension PostHelpRewardPick {
  enum Strings: String, LocalizedStringKeyProtocol {
    case limits = "Min.% ~ Max.%"
    case balance = "Your % balance: %"
  }
}
