//
//  PromotionBudgetPickModuleApi.swift
//  Pibble-iOS
//
//  Created by Sergey Kazakov on 25/05/2019.
//Copyright © 2019 com.kazai. All rights reserved.
//

//MARK: - PromotionBudgetPickRouter API
protocol PromotionBudgetPickRouterApi: RouterProtocol {
  func routeToNextStepWith(_ draft: PromotionDraft)
}

//MARK: - PromotionBudgetPickView API
protocol PromotionBudgetPickViewControllerApi: ViewControllerProtocol {
  func setHeaderViewModel(_ vm: PromotionBudgetPickHeaderViewModelProtocol)
  
  func setWalletBalance(_ balance: String)
  func setBudgetLimitations(_ limitations: String)
  func setDurationLimitations(_ limitations: String)
  
  func setBudgetCurrency(_ currency: String)
  
  func setNextButtonEnabled(_ isEnabled: Bool)
  
  func setBudget(_ budget: String)
  func setDuration(_ duration: String)
  
}

//MARK: - PromotionBudgetPickPresenter API
protocol PromotionBudgetPickPresenterApi: PresenterProtocol {
  func handleBudgetChangeAction(_ text: String)
  func handleDurationChangeAction(_ text: String)
  
  func handleNextStepAction()
  func handleHideAction()
  
  func presentDuration(_ duration: Int, totalBudget: BalanceProtocol, reach: (from: Int, to: Int))
  func presentCurrentWalletBalance(_ balance: BalanceProtocol)
  func presentBasicBudgetLimitations(_ limits: (min: BalanceProtocol, max: BalanceProtocol))
  func presentBasicDurationLimitations(_ limits: (min: Int, max: Int))
  func presentBudgetCurrency(_ currency: BalanceCurrency)
  
  func presentValidations( isBudgetValid: Bool, isDurationValid: Bool)
  
  func presentBudget(_ budget: Int)
  func presentDuration(_ duration: Int)
}

//MARK: - PromotionBudgetPickInteractor API
protocol PromotionBudgetPickInteractorApi: InteractorProtocol {
  var promotionDraft: PromotionDraft { get }
  
  func setDuration(_ duration: Int)
  func setBudget(_ budget: Int)

  func initialFetchData()
}


protocol PromotionBudgetPickHeaderViewModelProtocol {
  var reach: String { get }
  var budgetAndDuration: String { get }
}
