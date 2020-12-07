//
//  PromotionBudgetPickRouter.swift
//  Pibble-iOS
//
//  Created by Sergey Kazakov on 25/05/2019.
//Copyright © 2019 com.kazai. All rights reserved.
//

import Foundation

// MARK: - PromotionBudgetPickRouter class
final class PromotionBudgetPickRouter: Router {
  
}

// MARK: - PromotionBudgetPickRouter API
extension PromotionBudgetPickRouter: PromotionBudgetPickRouterApi {
  func routeToNextStepWith(_ draft: PromotionDraft) {
    let module = AppModules
      .Promotion
      .createPromotionConfirm(draft)
      .build()
      
    module?.view.transitionsController.presentationAnimator = FadeAnimationController(presenting: true)
    module?.view.transitionsController.dismissalAnimator = FadeAnimationController(presenting: false)
      
    module?.router.present(withPushfrom: presenter._viewController)
  }
}

// MARK: - PromotionBudgetPick Viper Components
fileprivate extension PromotionBudgetPickRouter {
  var presenter: PromotionBudgetPickPresenterApi {
    return _presenter as! PromotionBudgetPickPresenterApi
  }
}
