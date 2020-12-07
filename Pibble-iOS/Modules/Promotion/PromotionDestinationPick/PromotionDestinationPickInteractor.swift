//
//  PromotionDestinationPickInteractor.swift
//  Pibble-iOS
//
//  Created by Sergey Kazakov on 23/05/2019.
//Copyright © 2019 com.kazai. All rights reserved.
//

import Foundation 

// MARK: - PromotionDestinationPickInteractor Class
final class PromotionDestinationPickInteractor: Interactor {
  let promotionDraft: PromotionDraft
  
  init(promotionDraft: PromotionDraft) {
    self.promotionDraft = promotionDraft
    super.init()
  }
}

// MARK: - PromotionDestinationPickInteractor API
extension PromotionDestinationPickInteractor: PromotionDestinationPickInteractorApi {
  var destination: PromotionDestination? {
    return promotionDraft.destination
  }
  
  func setDestination(_ destination: PromotionDestination) {
    promotionDraft.destination = destination
    presenter.presentDestination(destination)
  }
}

// MARK: - Interactor Viper Components Api
private extension PromotionDestinationPickInteractor {
  var presenter: PromotionDestinationPickPresenterApi {
    return _presenter as! PromotionDestinationPickPresenterApi
  }
}
