//
//  PromotionPickModuleApi.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 21.08.2018.
//Copyright © 2018 com.kazai. All rights reserved.
//

//MARK: - PromotionPickRouter API

import UIKit

protocol PromotionPickRouterApi: RouterProtocol {
}

//MARK: - PromotionPickView API
protocol PromotionPickViewControllerApi: ViewControllerProtocol {
  func setActivitySelection(_ activity: PromotionPick.PromotionActivities, isSelected: Bool)
  
  func setCurrentBudget(_ value: String, currencySymbolValue: String)
  func setPromotionInfo(_ value: NSAttributedString)
  func setCurrentBalanceInfo(_ value: NSAttributedString)
  
  func setSliderViewModel(_ vm: PromotionPick.BudgetSliderViewModel, animated: Bool, delayed: Bool)
  func setDoneButtonEnabled(_ enabled: Bool)
}

//MARK: - PromotionPickPresenter API
protocol PromotionPickPresenterApi: PresenterProtocol {
  func handleHideAction()
  func handleDoneAction()
  
  func handleBudgetChange(_ value: Double)
  func handleBudgetChange(_ value: String)
  
  func handleActivitySelectionChange(_ activity: PromotionPick.PromotionActivities)

  func presentCurrentBalance(_ balance: BalanceProtocol)
  func presentUserReachability(_ reachibilityModel: PromotionPick.PromotionReachabilityModel)
  func presentActivitySelection(_ activity: PromotionPick.PromotionActivities, isSelected: Bool)
  
  func presentBudgetModel(_ budget: PromotionPick.BudgetModel)
  func presentIsPromotionValid(_ isValid: Bool)

}

//MARK: - PromotionPickInteractor API
protocol PromotionPickInteractorApi: InteractorProtocol {
  func initialFetchData()
  
  func setBudgetValue(_ value: Double)
  func changeActivitySelection(_ activity: PromotionPick.PromotionActivities)
  
  func getUpdatedDraftPromotion() -> CreatePromotionProtocol?

  func updateDraftWith(_ promotion: CreatePromotionProtocol)
}

protocol PromotionPickDelegateProtocol: class {
  func didSelectPromotion(_ promotion: CreatePromotionProtocol?)
  func selectedPromotion() -> CreatePromotionProtocol?
}
 


