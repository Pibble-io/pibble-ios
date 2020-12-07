//
//  PromotionServiceProtocol.swift
//  Pibble
//
//  Created by Sergey Kazakov on 26/05/2019.
//  Copyright © 2019 com.kazai. All rights reserved.
//

import Foundation

protocol PromotionServiceProtocol {
  var daysDurationLimitations: (from: Int, to: Int) { get }
  var dailyBudgetLimitations: (from: Int, to: Int) { get }
  var budgetCurrency: BalanceCurrency { get }
  
  var impressionsBudgetPerCent: Double { get }
  var interactionsBudgetPerCent: Double { get }
  
  func reachForTotalBudget(_ totalBudget: BalanceProtocol) -> (from: Int, to: Int)
  func totalBudgetFor(_ duration: Int, dailyBudget: Int) -> BalanceProtocol
  
  func getActions(complete: @escaping
    ResultCompleteHandler<([PromotionActionTypeProtocol]), PibbleError>)
  
  func createPromotionFor(_ post: PostingProtocol, promotionDraft: PromotionDraft, complete: @escaping CompleteHandler)
  
  func getStatisticsFor(_ promotion: PostPromotionProtocol, complete: @escaping
    ResultCompleteHandler<(PromotionStatisticsProtocol), PibbleError>)
  
  func closePromotion(_ promotion: PostPromotionProtocol, complete: @escaping CompleteHandler)
  
  func changePauseStateForPromotion(_ promotion: PostPromotionProtocol, complete: @escaping
    ResultCompleteHandler<(PostPromotionProtocol), PibbleError>)
}
