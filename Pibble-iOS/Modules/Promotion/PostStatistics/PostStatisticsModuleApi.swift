//
//  PostStatisticsModuleApi.swift
//  Pibble-iOS
//
//  Created by Sergey Kazakov on 18/06/2019.
//Copyright © 2019 com.kazai. All rights reserved.
//

import UIKit

//MARK: - PostStatisticsRouter API
protocol PostStatisticsRouterApi: RouterProtocol {
}

//MARK: - PostStatisticsView API
protocol PostStatisticsViewControllerApi: ViewControllerProtocol {
  func setEngagementViewModel(_ vm: PostStatisticsChartContainerViewModelProtocol?, animated: Bool)
  func setImpressionAmountsViewModel(_ vm: PostStatisticsAmountsViewModelProtocol?, animated: Bool)
  func setViewModels(_ vms: (amounts: PostStatisticsAmountsViewModelProtocol,
                          enagements: PostStatisticsChartContainerViewModelProtocol)?,
                     animated: Bool)
}

//MARK: - PostStatisticsPresenter API
protocol PostStatisticsPresenterApi: PresenterProtocol {
  func handleHideAction()
  func presentStatistics(_ statistics: EngagementStatisticsProtocol)
}

//MARK: - PostStatisticsInteractor API
protocol PostStatisticsInteractorApi: InteractorProtocol {
  func initialFetchData()
}

protocol PostStatisticsChartContainerViewModelProtocol: PromotionPostStatsChartContainerViewModelProtocol {
  
}

protocol PostStatisticsAmountsViewModelProtocol {
  var totalImpressionsAmount: String { get }
  var profileViewsAmount: String { get }
}
