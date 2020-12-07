//
//  PromotionPickInteractor.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 21.08.2018.
//Copyright © 2018 com.kazai. All rights reserved.
//

import Foundation

// MARK: - PromotionPickInteractor Class
final class PromotionPickInteractor: Interactor {
  fileprivate let minPromoBudgetLimitation: Double = 1.0
  
  fileprivate let walletService: WalletServiceProtocol
  
  fileprivate var minBudget: Double = 0.0
  fileprivate var maxBudget: Double = 1.0
  fileprivate var currency: BalanceCurrency {
    return draft.currency
  }
  
  fileprivate var currentBudget: Double {
    get {
      return draft.budget
    }
    set {
      draft.budget = floor(newValue)
      updatePresenter()
    }
  }
 
  fileprivate var isCurrentBudgetCorrect: Bool {
    guard minBudget.isLessThanOrEqualTo(currentBudget),
          currentBudget.isLessThanOrEqualTo(maxBudget),
          minPromoBudgetLimitation.isLessThanOrEqualTo(currentBudget),
          let balance = walletPibbleBalance,
          currentBudget.isLessThanOrEqualTo(balance.value)
    else {
      return false
    }
    
    return true
  }
  
  fileprivate var draft = PromotionPick.DraftPromotion() {
    didSet {
      updatePresenterPromoActivities()
    }
  }
  
  fileprivate var walletPibbleBalance: BalanceProtocol?
  
  init(walletService: WalletServiceProtocol) {
    self.walletService = walletService
  }
}

// MARK: - PromotionPickInteractor API
extension PromotionPickInteractor: PromotionPickInteractorApi {
  func setBudgetValue(_ value: Double) {
    currentBudget = max(minBudget, min(value, maxBudget))
  }
  
  func getUpdatedDraftPromotion() -> CreatePromotionProtocol? {
    guard isCurrentBudgetCorrect else {
      return nil
    }
    
    return draft
  }
  
  func updateDraftWith(_ promotion: CreatePromotionProtocol) {
    draft = PromotionPick.DraftPromotion(draft: promotion)
  }
  
  func initialFetchData() {
    walletService.getBalances { [weak self] in
      guard let strongSelf = self else {
        return
      }
      switch $0 {
      case .success(let balances):
        guard let balance = balances.first(where: { $0.currency == strongSelf.currency }) else {
          return
        }
       
        strongSelf.walletPibbleBalance = balance
        strongSelf.maxBudget = balance.value
        strongSelf.currentBudget = max(strongSelf.minBudget, min(strongSelf.currentBudget, strongSelf.maxBudget))
        
        strongSelf.updatePresenterPromoActivities()
      case .failure(let err):
        self?.presenter.handleError(err)
      }
    }
  }
  
  func changeActivitySelection(_ activity: PromotionPick.PromotionActivities) {
    var newValue = false
    switch activity {
    case .like:
      newValue = !draft.rewardTypeUpVote
      draft.rewardTypeUpVote = newValue
    case .share:
      newValue = !draft.rewardTypeShare
      draft.rewardTypeShare = newValue
    case .collect:
      newValue = !draft.rewardTypeCollect
      draft.rewardTypeCollect = newValue
    case .tag:
      newValue = !draft.rewardTypeTag
      draft.rewardTypeTag = newValue
    }
    
    presenter.presentActivitySelection(activity, isSelected: newValue)
    presenter.presentIsPromotionValid(isPromotionCorrect)
  }
}

// MARK: - Interactor Viper Components Api
private extension PromotionPickInteractor {
  var presenter: PromotionPickPresenterApi {
    return _presenter as! PromotionPickPresenterApi
  }
}

//MARK: Helpers

extension PromotionPickInteractor {
  fileprivate var isPromotionCorrect: Bool {
    guard isCurrentBudgetCorrect else {
      return false
    }
    
    let rewards = [draft.rewardTypeUpVote,
                   draft.rewardTypeShare,
                   draft.rewardTypeCollect,
                   draft.rewardTypeTag]
    
    return rewards.firstIndex(of: true) != nil
  }
  
  fileprivate func updatePresenterPromoActivities() {
    PromotionPick.PromotionActivities.allCases.forEach {
      switch $0 {
      case .like:
        presenter.presentActivitySelection($0, isSelected: draft.rewardTypeUpVote)
      case .share:
        presenter.presentActivitySelection($0, isSelected: draft.rewardTypeShare)
      case .collect:
        presenter.presentActivitySelection($0, isSelected: draft.rewardTypeCollect)
      case .tag:
        presenter.presentActivitySelection($0, isSelected: draft.rewardTypeTag)
      }
    }
    
    presenter.presentIsPromotionValid(isPromotionCorrect)
  }
  
  fileprivate func updatePresenter() {
    presenter.presentIsPromotionValid(isPromotionCorrect)
    let budgetModel = PromotionPick.BudgetModel(minBudget: minBudget,
                                                maxBudget: maxBudget, currency: currency, budget: currentBudget)
    
    let reachabilityModel = PromotionPick.PromotionReachabilityModel(currency: currency,
                                                                     budget: currentBudget,
                                                                     reachableUsers: currentBudget / 4.0)
    presenter.presentUserReachability(reachabilityModel)
    presenter.presentBudgetModel(budgetModel)
    
    guard let balance = walletPibbleBalance else {
      return
    }
    
    presenter.presentCurrentBalance(balance)
  }
}


