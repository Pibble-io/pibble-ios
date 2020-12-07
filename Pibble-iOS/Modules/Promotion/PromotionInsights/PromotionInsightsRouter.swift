//
//  PromotionInsightsRouter.swift
//  Pibble-iOS
//
//  Created by Sergey Kazakov on 12/06/2019.
//Copyright © 2019 com.kazai. All rights reserved.
//

import Foundation

// MARK: - PromotionInsightsRouter class
final class PromotionInsightsRouter: Router {
}

// MARK: - PromotionInsightsRouter API
extension PromotionInsightsRouter: PromotionInsightsRouterApi {
}

// MARK: - PromotionInsights Viper Components
fileprivate extension PromotionInsightsRouter {
  var presenter: PromotionInsightsPresenterApi {
    return _presenter as! PromotionInsightsPresenterApi
  }
}
