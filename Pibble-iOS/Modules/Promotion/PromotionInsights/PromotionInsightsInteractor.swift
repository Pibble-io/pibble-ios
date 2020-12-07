//
//  PromotionInsightsInteractor.swift
//  Pibble-iOS
//
//  Created by Sergey Kazakov on 12/06/2019.
//Copyright © 2019 com.kazai. All rights reserved.
//

import Foundation 

// MARK: - PromotionInsightsInteractor Class
final class PromotionInsightsInteractor: Interactor {
  fileprivate let promotionService: PromotionServiceProtocol
  fileprivate let promotion: PostPromotionProtocol
  
  init(promotionService: PromotionServiceProtocol, promotion: PostPromotionProtocol) {
    self.promotionService = promotionService
    self.promotion = promotion
    super.init()
  }
}

// MARK: - PromotionInsightsInteractor API
extension PromotionInsightsInteractor: PromotionInsightsInteractorApi {
  var promotionBudetCurrency: BalanceCurrency {
    return promotionService.budgetCurrency
  }
  
  func initialFetchData() {
    promotionService.getStatisticsFor(promotion) { [weak self] in
      switch $0 {
      case .success(let promotionStats):
        self?.presenter.presentStatistics(promotionStats)
      case .failure(let error):
        self?.presenter.handleError(error)
      }
    }
  }
}

// MARK: - Interactor Viper Components Api
private extension PromotionInsightsInteractor {
  var presenter: PromotionInsightsPresenterApi {
    return _presenter as! PromotionInsightsPresenterApi
  }
}
