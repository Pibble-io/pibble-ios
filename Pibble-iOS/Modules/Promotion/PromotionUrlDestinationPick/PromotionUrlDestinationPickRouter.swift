//
//  PromotionUrlDestinationPickRouter.swift
//  Pibble-iOS
//
//  Created by Sergey Kazakov on 24/05/2019.
//Copyright © 2019 com.kazai. All rights reserved.
//

import Foundation

// MARK: - PromotionUrlDestinationPickRouter class
final class PromotionUrlDestinationPickRouter: Router {
}

// MARK: - PromotionUrlDestinationPickRouter API
extension PromotionUrlDestinationPickRouter: PromotionUrlDestinationPickRouterApi {
}

// MARK: - PromotionUrlDestinationPick Viper Components
fileprivate extension PromotionUrlDestinationPickRouter {
  var presenter: PromotionUrlDestinationPickPresenterApi {
    return _presenter as! PromotionUrlDestinationPickPresenterApi
  }
}
