//
//  PromotionInsightsPresenter.swift
//  Pibble-iOS
//
//  Created by Sergey Kazakov on 12/06/2019.
//Copyright © 2019 com.kazai. All rights reserved.
//

import Foundation

// MARK: - PromotionInsightsPresenter Class
final class PromotionInsightsPresenter: Presenter {
  override func viewDidLoad() {
    super.viewDidLoad()
    viewController.setViewModels(nil, animated: false)
    interactor.initialFetchData()
  }
}

// MARK: - PromotionInsightsPresenter API
extension PromotionInsightsPresenter: PromotionInsightsPresenterApi {
  
  func handleHideAction() {
    router.dismiss()
  }
  func presentStatistics(_ statistics: PromotionStatisticsProtocol) {
    let dateViewModel = PromotionInsights.PostStatsHeaderViewModel(promotionStats: statistics)
    let budgetViewModel = PromotionInsights.PostStatsBudgetViewModel(promotionStats: statistics, promotionCurrency: interactor.promotionBudetCurrency)
    
    let engagementViewModel = PromotionInsights.PostEngagementChartContainerViewModel(promotionStats: statistics)
    
    let impressionsViewModel = PromotionInsights.PostImpressionsChartContainerViewModel(promotionStats: statistics)
//
//    viewController.setDateViewModel(dateViewModel, animated: false)
//    viewController.setStatsBudgetViewModel(budgetViewModel, animated: false)
//    viewController.setEngagementViewModel(engagementViewModel, animated: false)
//    viewController.setImpressionViewModel(impressionsViewModel, animated: isPresented)
//
    viewController.setViewModels((dateViewModel, budgetViewModel, engagementViewModel, impressionsViewModel), animated: isPresented)
  }
}

// MARK: - PromotionInsights Viper Components
fileprivate extension PromotionInsightsPresenter {
  var viewController: PromotionInsightsViewControllerApi {
    return _viewController as! PromotionInsightsViewControllerApi
  }
  var interactor: PromotionInsightsInteractorApi {
    return _interactor as! PromotionInsightsInteractorApi
  }
  var router: PromotionInsightsRouterApi {
    return _router as! PromotionInsightsRouterApi
  }
}
