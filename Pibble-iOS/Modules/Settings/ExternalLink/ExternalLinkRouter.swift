//
//  ExternalLinkRouter.swift
//  Pibble-iOS
//
//  Created by Sergey Kazakov on 20/05/2019.
//Copyright © 2019 com.kazai. All rights reserved.
//

import Foundation

// MARK: - ExternalLinkRouter class
final class ExternalLinkRouter: Router {
}

// MARK: - ExternalLinkRouter API
extension ExternalLinkRouter: ExternalLinkRouterApi {
}

// MARK: - ExternalLink Viper Components
fileprivate extension ExternalLinkRouter {
  var presenter: ExternalLinkPresenterApi {
    return _presenter as! ExternalLinkPresenterApi
  }
}
