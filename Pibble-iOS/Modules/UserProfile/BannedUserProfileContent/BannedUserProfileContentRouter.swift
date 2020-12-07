//
//  BannedUserProfileContentRouter.swift
//  Pibble-iOS
//
//  Created by Sergey Kazakov on 31/05/2019.
//Copyright © 2019 com.kazai. All rights reserved.
//

import Foundation

// MARK: - BannedUserProfileContentRouter class
final class BannedUserProfileContentRouter: Router {
}

// MARK: - BannedUserProfileContentRouter API
extension BannedUserProfileContentRouter: BannedUserProfileContentRouterApi {
}

// MARK: - BannedUserProfileContent Viper Components
fileprivate extension BannedUserProfileContentRouter {
  var presenter: BannedUserProfileContentPresenterApi {
    return _presenter as! BannedUserProfileContentPresenterApi
  }
}
