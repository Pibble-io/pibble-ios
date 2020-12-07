//
//  PostStatisticsPresenter.swift
//  Pibble-iOS
//
//  Created by Sergey Kazakov on 18/06/2019.
//Copyright © 2019 com.kazai. All rights reserved.
//

import Foundation

// MARK: - PostStatisticsPresenter Class
final class PostStatisticsPresenter: Presenter {
  override func viewDidLoad() {
    super.viewDidLoad()
    viewController.setViewModels(nil, animated: false)
    interactor.initialFetchData()
  }
}

// MARK: - PostStatisticsPresenter API
extension PostStatisticsPresenter: PostStatisticsPresenterApi {
  func handleHideAction() {
    router.dismiss()
  }
  
  func presentStatistics(_ statistics: EngagementStatisticsProtocol) {
    let engagementViewModel = PostStatistics.PostEngagementChartContainerViewModel(postStats: statistics)
    let amountsViewModel = PostStatistics.AmountsViewModel(postStats: statistics)
    viewController.setViewModels((amountsViewModel,engagementViewModel), animated: isPresented)
  }
}

// MARK: - PostStatistics Viper Components
fileprivate extension PostStatisticsPresenter {
  var viewController: PostStatisticsViewControllerApi {
    return _viewController as! PostStatisticsViewControllerApi
  }
  var interactor: PostStatisticsInteractorApi {
    return _interactor as! PostStatisticsInteractorApi
  }
  var router: PostStatisticsRouterApi {
    return _router as! PostStatisticsRouterApi
  }
}
