//
//  PromotionPickPresenter.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 21.08.2018.
//Copyright © 2018 com.kazai. All rights reserved.
//

import UIKit

// MARK: - PromotionPickPresenter Class
final class PromotionPickPresenter: Presenter {
  fileprivate lazy var numberFormatter: NumberFormatter = {
    return NumberFormatter()
  }()
 
  fileprivate weak var promotionPickDelegate: PromotionPickDelegateProtocol?
  
  override func viewDidAppear() {
    super.viewDidAppear()
    if let promotion = promotionPickDelegate?.selectedPromotion() {
      interactor.updateDraftWith(promotion)
    }
    interactor.initialFetchData()
  }
  
  init(promotionPickDelegate: PromotionPickDelegateProtocol) {
    self.promotionPickDelegate = promotionPickDelegate
  }
  
  fileprivate var budgetSliderViewModel: PromotionPick.BudgetSliderViewModel? {
    didSet {
      guard let viewModel = budgetSliderViewModel else {
        return
      }
      
      let shoudldDelay = oldValue != nil
      viewController.setSliderViewModel(viewModel, animated: true, delayed: shoudldDelay)
    }
  }
}

// MARK: - PromotionPickPresenter API
extension PromotionPickPresenter: PromotionPickPresenterApi {
  func handleBudgetChange(_ value: Double) {
    interactor.setBudgetValue(value)
  }
  
  func handleActivitySelectionChange(_ activity: PromotionPick.PromotionActivities) {
    interactor.changeActivitySelection(activity)
  }
  
  func handleBudgetChange(_ value: String) {
    let amountValueString = value.count > 0 ? value : "0"
    guard let amount = numberFormatter.number(from: amountValueString)?.doubleValue else {
      interactor.setBudgetValue(0.0)
      return
    }
    
    interactor.setBudgetValue(amount)
  }
  
  
  func handleHideAction() {
    router.dismiss()
  }
  
  func handleDoneAction() {
    promotionPickDelegate?.didSelectPromotion(interactor.getUpdatedDraftPromotion())
    router.dismiss()
  }
  
  func presentIsPromotionValid(_ isValid: Bool) {
    viewController.setDoneButtonEnabled(isValid)
  }
  
  func presentBudgetModel(_ budgetModel: PromotionPick.BudgetModel) {
    viewController.setCurrentBudget(String(format:"%.0f", budgetModel.budget), currencySymbolValue: budgetModel.currency.symbol.uppercased())
    
    budgetSliderViewModel = PromotionPick.BudgetSliderViewModel(minValue: Float(budgetModel.minBudget),
                                                                maxValue: Float(budgetModel.maxBudget),
                                                                currentValue: Float(budgetModel.budget))
  }
  
  func presentUserReachability(_ reachibilityModel: PromotionPick.PromotionReachabilityModel) {
    let attrString = NSMutableAttributedString()
    
    attrString.append(NSAttributedString(string: PromotionPick.Strings.userPromotionReachabilityInfo[0].localize(), attributes:
      [NSAttributedString.Key.font : UIFont.AvenirNextMedium(size: 15),
       NSAttributedString.Key.foregroundColor : UIConstants.Colors.userPromotionReachabilityInfo]))
    
    let budgetString = "\(String(format:"%.0f", reachibilityModel.budget)) \(reachibilityModel.currency.symbol.uppercased())"
    
    attrString.append(NSAttributedString(string: budgetString, attributes:
      [NSAttributedString.Key.font : UIFont.AvenirNextDemiBold(size: 15),
       NSAttributedString.Key.foregroundColor : UIConstants.Colors.userPromotionBudgetValue]))
    
    attrString.append(NSAttributedString(string: PromotionPick.Strings.userPromotionReachabilityInfo[1].localize(), attributes:
      [NSAttributedString.Key.font : UIFont.AvenirNextMedium(size: 15),
       NSAttributedString.Key.foregroundColor : UIConstants.Colors.userPromotionReachabilityInfo]))
    
    attrString.append(NSAttributedString(string: String(Int(reachibilityModel.reachableUsers)), attributes:
      [NSAttributedString.Key.font : UIFont.AvenirNextDemiBold(size: 15),
       NSAttributedString.Key.foregroundColor : UIConstants.Colors.userPromotionReachabilityValue]))
    
    attrString.append(NSAttributedString(string: PromotionPick.Strings.userPromotionReachabilityInfo[2].localize(), attributes:
      [NSAttributedString.Key.font : UIFont.AvenirNextMedium(size: 15),
       NSAttributedString.Key.foregroundColor : UIConstants.Colors.userPromotionReachabilityInfo]))
    
    viewController.setPromotionInfo(attrString)
  }
  
  func presentActivitySelection(_ activity: PromotionPick.PromotionActivities, isSelected: Bool) {
    viewController.setActivitySelection(activity, isSelected: isSelected)
  }
  
  func presentCurrentBalance(_ balance: BalanceProtocol) {
    let attrString = NSMutableAttributedString()
    let balanceString = PromotionPick.Strings.currentBalanceWithSymbol(balance.currency.symbol)
    
    let attrBalanceString = NSAttributedString(string: balanceString, attributes:
      [NSAttributedString.Key.font : UIFont.AvenirNextMedium(size: 15),
       NSAttributedString.Key.foregroundColor : UIConstants.Colors.currentBalance])
    
    attrString.append(attrBalanceString)
    
    let balanceValueString = "\(String(format:"%.1f", balance.value)) \(balance.currency.symbol.uppercased())"
    
    let attrBalanceValueString = NSAttributedString(string: balanceValueString, attributes:
        [NSAttributedString.Key.font : UIFont.AvenirNextDemiBold(size: 15),
         NSAttributedString.Key.foregroundColor : UIConstants.Colors.currentBalanceValue
      ])
    attrString.append(attrBalanceValueString)
    
    viewController.setCurrentBalanceInfo(attrString)
  }
}

// MARK: - PromotionPick Viper Components
fileprivate extension PromotionPickPresenter {
    var viewController: PromotionPickViewControllerApi {
        return _viewController as! PromotionPickViewControllerApi
    }
    var interactor: PromotionPickInteractorApi {
        return _interactor as! PromotionPickInteractorApi
    }
    var router: PromotionPickRouterApi {
        return _router as! PromotionPickRouterApi
    }
}

fileprivate enum UIConstants {
  
  
  enum Colors {
    static let currentBalance = UIColor.gray70
    static let currentBalanceValue = UIColor.bluePibble
    
    static let userPromotionBudgetValue = UIColor.gray70
    static let userPromotionReachabilityValue = UIColor.gray70
    static let userPromotionReachabilityInfo = UIColor.gray191
  }
}

extension PromotionPick {
  enum Strings: String, LocalizedStringKeyProtocol {
    case currentBalance = "Your current % Token Balance is "
    
    case promotionalBudget = "Your promotional budget has been set at "
    case reach = ". Your media will reach about "
    case people = " people."
    
    case zeroValue = "0"
    
    static func currentBalanceWithSymbol(_ symbol: String) -> String {
      return Strings.currentBalance.localize(value: symbol)
    }
    
    static let userPromotionReachabilityInfo = [
      promotionalBudget, reach, people
    ]
  }
}
