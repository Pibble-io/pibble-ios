//
//  PromotionBudgetPickModuleScope.swift
//  Pibble-iOS
//
//  Created by Sergey Kazakov on 25/05/2019.
//Copyright © 2019 com.kazai. All rights reserved.
//

import Foundation

enum PromotionBudgetPick {
  
  static let numberToStringsFormatter: NumberFormatter = {
    let formatter = NumberFormatter()
    formatter.formatterBehavior = NumberFormatter.Behavior.behavior10_4
    formatter.numberStyle = NumberFormatter.Style.decimal
    return formatter
  }()
  
  static func toStringWithCurrencyFormatter(_ number: Int) -> String {
    let number = NSNumber(value: number)
    return numberToStringsFormatter.string(from: number) ?? ""
  }
  
  static func toStringWithCurrencyFormatter(_ number: Double) -> String {
    let number = NSNumber(value: number)
    return numberToStringsFormatter.string(from: number) ?? ""
  }
  
  struct HeaderViewModel: PromotionBudgetPickHeaderViewModelProtocol {
    let reach: String
    
    let budgetAndDuration: String
    
    init(duration: Int, totalBudget: BalanceProtocol, reach: (from: Int, to: Int)) {
      self.reach = "\(PromotionBudgetPick.toStringWithCurrencyFormatter(reach.from)) - \(PromotionBudgetPick.toStringWithCurrencyFormatter(reach.to))"
      
      let budgetValue = PromotionBudgetPick.toStringWithCurrencyFormatter(totalBudget.value)
      
      let durationString = "\(duration) \(Strings.days.localize())"
      let budgetString = "\(budgetValue) \(totalBudget.currency.symbol)"
      self.budgetAndDuration = "\(budgetString) / \(durationString)"
    }
  }
}

extension PromotionBudgetPick {
  enum Strings: String, LocalizedStringKeyProtocol {
    case days = "Days"
    
    case dailyBudget = "%/Daily"
    case availableBalance = "Your % balance: %"
    case budgetLimits = "Min.% ~ Max.% Daily"
    case durationLimits = "% Day ~ % Days"
  }
}
