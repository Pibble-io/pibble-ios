//
//  PostStatisticsRouter.swift
//  Pibble-iOS
//
//  Created by Sergey Kazakov on 18/06/2019.
//Copyright © 2019 com.kazai. All rights reserved.
//

import Foundation

// MARK: - PostStatisticsRouter class
final class PostStatisticsRouter: Router {
}

// MARK: - PostStatisticsRouter API
extension PostStatisticsRouter: PostStatisticsRouterApi {
}

// MARK: - PostStatistics Viper Components
fileprivate extension PostStatisticsRouter {
  var presenter: PostStatisticsPresenterApi {
    return _presenter as! PostStatisticsPresenterApi
  }
}
