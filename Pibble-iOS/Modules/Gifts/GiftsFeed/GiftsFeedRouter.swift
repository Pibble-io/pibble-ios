//
//  GiftsFeedRouter.swift
//  Pibble-iOS
//
//  Created by Sergey Kazakov on 20/05/2019.
//Copyright © 2019 com.kazai. All rights reserved.
//

import Foundation

// MARK: - GiftsFeedRouter class
final class GiftsFeedRouter: Router {
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

// MARK: - GiftsFeedRouter API
extension GiftsFeedRouter: GiftsFeedRouterApi {
}

// MARK: - GiftsFeed Viper Components
fileprivate extension GiftsFeedRouter {
  var presenter: GiftsFeedPresenterApi {
    return _presenter as! GiftsFeedPresenterApi
  }
}
