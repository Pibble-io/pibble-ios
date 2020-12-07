//
//  PromotionDestinationPickRouter.swift
//  Pibble-iOS
//
//  Created by Sergey Kazakov on 23/05/2019.
//Copyright © 2019 com.kazai. All rights reserved.
//

import UIKit

// MARK: - PromotionDestinationPickRouter class
final class PromotionDestinationPickRouter: Router {
}

// MARK: - PromotionDestinationPickRouter API
extension PromotionDestinationPickRouter: PromotionDestinationPickRouterApi {
  func routeToPickUrlDestination(_ delegate: PromotionUrlDestinationPickDelegateProtocol) {
    AppModules
      .Promotion
      .promotionUrlDestinationPick(delegate)
      .build()?
      .router.present(withPushfrom: presenter._viewController)
  }
  
  func routeToNextStepWith(_ draft: PromotionDraft) {
    let module = AppModules
      .Promotion
      .promotionBudgetPick(draft)
      .build()
   
    module?.view.transitionsController.presentationAnimator = FadeAnimationController(presenting: true)
    module?.view.transitionsController.dismissalAnimator = FadeAnimationController(presenting: false)
    
    module?.router.present(withPushfrom: presenter._viewController)
  }
}

// MARK: - PromotionDestinationPick Viper Components
fileprivate extension PromotionDestinationPickRouter {
  var presenter: PromotionDestinationPickPresenterApi {
    return _presenter as! PromotionDestinationPickPresenterApi
  }
}
