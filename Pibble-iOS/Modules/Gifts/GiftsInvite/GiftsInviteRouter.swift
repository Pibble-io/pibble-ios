//
//  GiftsInviteRouter.swift
//  Pibble-iOS
//
//  Created by Sergey Kazakov on 20/05/2019.
//Copyright © 2019 com.kazai. All rights reserved.
//

import Foundation

// MARK: - GiftsInviteRouter class
final class GiftsInviteRouter: Router {
}

// MARK: - GiftsInviteRouter API
extension GiftsInviteRouter: GiftsInviteRouterApi {
}

// MARK: - GiftsInvite Viper Components
fileprivate extension GiftsInviteRouter {
  var presenter: GiftsInvitePresenterApi {
    return _presenter as! GiftsInvitePresenterApi
  }
}
