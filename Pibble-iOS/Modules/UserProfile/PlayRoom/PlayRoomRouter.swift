//
//  PlayRoomRouter.swift
//  Pibble-iOS
//
//  Created by Sergey Kazakov on 20/05/2019.
//Copyright © 2019 com.kazai. All rights reserved.
//

import Foundation

// MARK: - PlayRoomRouter class
final class PlayRoomRouter: Router {
  func routeToSearchScreen() {
    let module = AppModules
      .Gifts
      .giftsFeed(.giftSearch)
      .build()

    module?.view.transitionsController.presentationAnimator = FadeAnimationController(presenting: true)
    module?.view.transitionsController.dismissalAnimator = FadeAnimationController(presenting: false)
    module?.router.present(withPushfrom: presenter._viewController)
  }
}

// MARK: - PlayRoomRouter API
extension PlayRoomRouter: PlayRoomRouterApi {
}

// MARK: - PlayRoom Viper Components
fileprivate extension PlayRoomRouter {
  var presenter: PlayRoomPresenterApi {
    return _presenter as! PlayRoomPresenterApi
  }
}
