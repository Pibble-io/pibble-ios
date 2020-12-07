//
//  PromotionBudgetPickPresenter.swift
//  Pibble-iOS
//
//  Created by Sergey Kazakov on 25/05/2019.
//Copyright © 2019 com.kazai. All rights reserved.
//

import Foundation

// MARK: - PromotionBudgetPickPresenter Class
final class PromotionBudgetPickPresenter: Presenter {
  fileprivate lazy var numberFormatter = {
    return NumberFormatter()
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    interactor.initialFetchData()
  }
}

// MARK: - PromotionBudgetPickPresenter API
extension PromotionBudgetPickPresenter: PromotionBudgetPickPresenterApi {
  func presentBudget(_ budget: Int) {
    viewController.setBudget(String(budget))
  }
  
  func presentDuration(_ duration: Int) {
    viewController.setDuration(String(duration))
  }
  
  func presentValidations(isBudgetValid: Bool, isDurationValid: Bool) {
    viewController.setNextButtonEnabled(isBudgetValid && isDurationValid)
  }
  
  func presentBasicDurationLimitations(_ limits: (min: Int, max: Int)) {
    let limitsStrings = [limits.min, limits.max].map {
      return String($0)
    }
    
    let budgetLimitsString = PromotionBudgetPick.Strings.durationLimits.localize(values: limitsStrings)
    viewController.setDurationLimitations(budgetLimitsString)
  }
  
  func presentBasicBudgetLimitations(_ limits: (min: BalanceProtocol, max: BalanceProtocol)) {
    let values: [String] = [limits.min, limits.max].map {
      
      let balanceValue = PromotionBudgetPick.toStringWithCurrencyFormatter($0.value)
      let currency = $0.currency.symbol
      let currencyWithValue = "\(balanceValue) \(currency)"
      return currencyWithValue
    }
    
    let budgetLimitsString = PromotionBudgetPick.Strings.budgetLimits.localize(values: values)
    viewController.setBudgetLimitations(budgetLimitsString)
  }
  
  func presentBudgetCurrency(_ currency: BalanceCurrency) {
    let currency = currency.symbol
    
    let dailyBudget = PromotionBudgetPick.Strings.dailyBudget.localize(value: currency)
    viewController.setBudgetCurrency(dailyBudget)
  }
  
  func presentCurrentWalletBalance(_ balance: BalanceProtocol) {
    let balanceValue = PromotionBudgetPick.toStringWithCurrencyFormatter(balance.value)
    let currency = balance.currency.symbol
    let currencyWithValue = "\(balanceValue) \(currency)"
    
    let availableBalance = PromotionBudgetPick.Strings.availableBalance.localize(values: currency, currencyWithValue)
    viewController.setWalletBalance(availableBalance)
  }
  
  func presentDuration(_ duration: Int, totalBudget: BalanceProtocol, reach: (from: Int, to: Int)) {
    let viewModel = PromotionBudgetPick.HeaderViewModel(duration: duration,
                                                        totalBudget: totalBudget,
                                                        reach: reach)
    viewController.setHeaderViewModel(viewModel)
  }
  
  func handleBudgetChangeAction(_ text: String) {
    guard let intValue = numberFormatter.number(from: text)?.intValue else {
      interactor.setBudget(0)
      return
    }
    
    interactor.setBudget(intValue)
  }
  
  func handleDurationChangeAction(_ text: String) {
    guard let intValue = numberFormatter.number(from: text)?.intValue else {
      interactor.setDuration(0)
      return
    }
    
    interactor.setDuration(intValue)
  }
  
  func handleNextStepAction() {
    router.routeToNextStepWith(interactor.promotionDraft)
  }
  
  func handleHideAction() {
    router.dismiss()
  }
}

// MARK: - PromotionBudgetPick Viper Components
fileprivate extension PromotionBudgetPickPresenter {
  var viewController: PromotionBudgetPickViewControllerApi {
    return _viewController as! PromotionBudgetPickViewControllerApi
  }
  var interactor: PromotionBudgetPickInteractorApi {
    return _interactor as! PromotionBudgetPickInteractorApi
  }
  var router: PromotionBudgetPickRouterApi {
    return _router as! PromotionBudgetPickRouterApi
  }
}
