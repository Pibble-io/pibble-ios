//
//  PromotionInsightsModuleApi.swift
//  Pibble-iOS
//
//  Created by Sergey Kazakov on 12/06/2019.
//Copyright © 2019 com.kazai. All rights reserved.
//

import UIKit

//MARK: - PromotionInsightsRouter API
protocol PromotionInsightsRouterApi: RouterProtocol {
}

//MARK: - PromotionInsightsView API
protocol PromotionInsightsViewControllerApi: ViewControllerProtocol {
  func setDateViewModel(_ vm: PromotionPostStatsHeaderViewModelProtocol?, animated: Bool)
  func setStatsBudgetViewModel(_ vm: PromotionPostStatsBudgetViewModelProtocol?, animated: Bool)
  func setEngagementViewModel(_ vm: PromotionPostStatsChartContainerViewModelProtocol?, animated: Bool)
  func setImpressionViewModel(_ vm: PromotionPostStatsChartContainerViewModelProtocol?, animated: Bool)
  
  func setViewModels(_ vms: (header: PromotionPostStatsHeaderViewModelProtocol,
                              budget: PromotionPostStatsBudgetViewModelProtocol,
                              enagements: PromotionPostStatsChartContainerViewModelProtocol,
                              impression: PromotionPostStatsChartContainerViewModelProtocol)?,
                     animated: Bool)
  
}

//MARK: - PromotionInsightsPresenter API
protocol PromotionInsightsPresenterApi: PresenterProtocol {
  func handleHideAction() 
  func presentStatistics(_ statistics: PromotionStatisticsProtocol)
}

//MARK: - PromotionInsightsInteractor API
protocol PromotionInsightsInteractorApi: InteractorProtocol {
  var promotionBudetCurrency: BalanceCurrency { get }
  func initialFetchData()
}

protocol PromotionPostStatsChartContainerViewModelProtocol {
  var title: String { get }
  var value: String { get }
  var barsViewModels: [PromotionPostStatsChartBarViewModelProtocol] { get }
}

protocol PromotionPostStatsChartBarViewModelProtocol {
  var barColor: UIColor { get }
  var titleColor: UIColor { get }
  var relativeValue: Double { get }
  var value: String { get }
  var title: String { get }
}

protocol PromotionPostStatsHeaderViewModelProtocol {
  var date: String { get }
}

protocol PromotionPostStatsBudgetViewModelProtocol {
  var budgetAmount: String { get }
  var progress: Double { get }
  
  var usedBudgetProgress: String { get }
  var leftBudgetProgress: String { get }
  
  var totalBudgetAmount: String { get }
  var usedBudgetAmount: String { get }
  var leftBudgetAmount: String { get }
}
