//
//  TopBannerInfoRouter.swift
//  Pibble-iOS
//
//  Created by Sergey Kazakov on 20/05/2019.
//Copyright © 2019 com.kazai. All rights reserved.
//

import Foundation

// MARK: - TopBannerInfoRouter class
final class TopBannerInfoRouter: Router {
}

// MARK: - TopBannerInfoRouter API
extension TopBannerInfoRouter: TopBannerInfoRouterApi {
}

// MARK: - TopBannerInfo Viper Components
fileprivate extension TopBannerInfoRouter {
  var presenter: TopBannerInfoPresenterApi {
    return _presenter as! TopBannerInfoPresenterApi
  }
}
