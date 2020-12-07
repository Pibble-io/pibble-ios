//
//  MediaDetailRouter.swift
//  Pibble-iOS
//
//  Created by Sergey Kazakov on 06/05/2019.
//Copyright © 2019 com.kazai. All rights reserved.
//

import Foundation

// MARK: - MediaDetailRouter class
final class MediaDetailRouter: Router {
}

// MARK: - MediaDetailRouter API
extension MediaDetailRouter: MediaDetailRouterApi {
}

// MARK: - MediaDetail Viper Components
fileprivate extension MediaDetailRouter {
  var presenter: MediaDetailPresenterApi {
    return _presenter as! MediaDetailPresenterApi
  }
}
