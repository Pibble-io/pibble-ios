//
//  GoodsPostDetailRouter.swift
//  Pibble-iOS
//
//  Created by Sergey Kazakov on 30/07/2019.
//Copyright © 2019 com.kazai. All rights reserved.
//

import Foundation

// MARK: - GoodsPostDetailRouter class
final class GoodsPostDetailRouter: Router {
}

// MARK: - GoodsPostDetailRouter API
extension GoodsPostDetailRouter: GoodsPostDetailRouterApi {
}

// MARK: - GoodsPostDetail Viper Components
fileprivate extension GoodsPostDetailRouter {
  var presenter: GoodsPostDetailPresenterApi {
    return _presenter as! GoodsPostDetailPresenterApi
  }
}
