//
//  PromotionPickRouter.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 21.08.2018.
//Copyright © 2018 com.kazai. All rights reserved.
//

import Foundation

// MARK: - PromotionPickRouter class
final class PromotionPickRouter: Router {
}

// MARK: - PromotionPickRouter API
extension PromotionPickRouter: PromotionPickRouterApi {
}

// MARK: - PromotionPick Viper Components
fileprivate extension PromotionPickRouter {
    var presenter: PromotionPickPresenterApi {
        return _presenter as! PromotionPickPresenterApi
    }
}
