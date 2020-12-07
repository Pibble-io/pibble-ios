//
//  PromotionBudgetPickInteractor.swift
//  Pibble-iOS
//
//  Created by Sergey Kazakov on 25/05/2019.
//Copyright © 2019 com.kazai. All rights reserved.
//

import Foundation 

// MARK: - PromotionBudgetPickInteractor Class
final class PromotionBudgetPickInteractor: Interactor {
  fileprivate let promotionService: PromotionServiceProtocol
  fileprivate let accountProfileService: AccountProfileServiceProtocol
  
  fileprivate let inputsDurationLimits = (min: 0, max: 100)
  fileprivate let inputsBudgetLimits = (min: 0, max: 1000000)
  let promotionDraft: PromotionDraft
  
  fileprivate var duration: Int = 0 {
    didSet {
      promotionDraft.promotionDuration = duration
      updateTotalBudget()
    }
  }
  
  fileprivate var dailyBudget: Int = 0 {
    didSet {
      promotionDraft.dailyBudget = Balance(currency: promotionService.budgetCurrency,
                               value: Double(dailyBudget))
      updateTotalBudget()
    }
  }
  
  init(promotionService: PromotionServiceProtocol, accountProfileService: AccountProfileServiceProtocol, promotionDraft: PromotionDraft) {
    self.promotionService = promotionService
    self.accountProfileService = accountProfileService
    self.promotionDraft = promotionDraft
  }
}

// MARK: - PromotionBudgetPickInteractor API
extension PromotionBudgetPickInteractor: PromotionBudgetPickInteractorApi {
  func setDuration(_ duration: Int) {
    let limitationsValidatedDuration = max(inputsDurationLimits.min, min(inputsDurationLimits.max, duration))
    self.duration = limitationsValidatedDuration
    presenter.presentDuration(self.duration)
  }
  
  func setBudget(_ budget: Int) {
    let limitationsValidatedBudget = max(inputsBudgetLimits.min, min(inputsBudgetLimits.max, budget))
    self.dailyBudget = limitationsValidatedBudget
    presenter.presentBudget(dailyBudget)
  }
  
  func initialFetchData() {
    if let accountProfile = accountProfileService.currentUserAccount {
      let balance = getAvailableBudgetFor(accountProfile)
      presenter.presentCurrentWalletBalance(balance)
    }
   
    duration = promotionDraft.promotionDuration ?? promotionService.daysDurationLimitations.from
    dailyBudget = Int(promotionDraft.dailyBudget?.value ?? Double(promotionService.dailyBudgetLimitations.from))
    
    let limits = getBudgetLimits()
    
    presenter.presentBudget(dailyBudget)
    presenter.presentDuration(duration)
    
    presenter.presentBasicBudgetLimitations((min: limits.min, max: limits.max))
    presenter.presentBasicDurationLimitations((min: promotionService.daysDurationLimitations.from,
                                               max: promotionService.daysDurationLimitations.to))
    presenter.presentBudgetCurrency(promotionService.budgetCurrency)
    accountProfileService.getProfile { [weak self] in
      guard let strongSelf = self else {
        return
      }
      switch $0 {
      case .success(let accountProfile):
        let balance = strongSelf.getAvailableBudgetFor(accountProfile)
        strongSelf.presenter.presentCurrentWalletBalance(balance)
      case .failure(let error):
        strongSelf.presenter.handleError(error)
      }
    }
  }
}

//MARK:- Helpers

extension PromotionBudgetPickInteractor {
  fileprivate func updateTotalBudget() {
    let totalBudget = promotionService.totalBudgetFor(duration, dailyBudget: dailyBudget)
    let reach = promotionService.reachForTotalBudget(totalBudget)
    
    let isBudgetValid = dailyBudget >= promotionService.dailyBudgetLimitations.from &&
      dailyBudget <= promotionService.dailyBudgetLimitations.to
    
    let isDurationValid = duration >= promotionService.daysDurationLimitations.from &&
      duration <= promotionService.daysDurationLimitations.to
   
    presenter.presentValidations(isBudgetValid: isBudgetValid, isDurationValid: isDurationValid)
    presenter.presentDuration(duration, totalBudget: totalBudget, reach: reach)
  }
  
  
  fileprivate func getBudgetLimits() -> (min: BalanceProtocol, max: BalanceProtocol) {
    let minBudget = Balance(currency: promotionService.budgetCurrency, value: Double(promotionService.dailyBudgetLimitations.from))
    let maxBudget = Balance(currency: promotionService.budgetCurrency, value: Double(promotionService.dailyBudgetLimitations.to))
    
    return (minBudget, maxBudget)
  }
  
  fileprivate func getAvailableBudgetFor(_ accountProfile: AccountProfileProtocol) -> BalanceProtocol {
    let walletWithPromotionBalance = accountProfile.walletBalances.first(where: { $0.currency == promotionService.budgetCurrency } )
    guard let balance = walletWithPromotionBalance else {
      return Balance(currency: promotionService.budgetCurrency, value: 0.0)
    }
    
    return balance
  }
}


// MARK: - Interactor Viper Components Api
private extension PromotionBudgetPickInteractor {
  var presenter: PromotionBudgetPickPresenterApi {
    return _presenter as! PromotionBudgetPickPresenterApi
  }
}
