//
//  CreatePromotionConfirmRouter.swift
//  Pibble-iOS
//
//  Created by Sergey Kazakov on 05/06/2019.
//Copyright © 2019 com.kazai. All rights reserved.
//

import Foundation

// MARK: - CreatePromotionConfirmRouter class
final class CreatePromotionConfirmRouter: Router {
}

// MARK: - CreatePromotionConfirmRouter API
extension CreatePromotionConfirmRouter: CreatePromotionConfirmRouterApi {
  func routeToFinish() {
    dismiss(withPop: false)
  }
  
  func routeToPinCodeUnlock(delegate: WalletPinCodeUnlockDelegateProtocol) {
    AppModules
      .Wallet
      .walletPinCode(.unlock, delegate)
      .build()?
      .router.present(from: _presenter._viewController)
  }
  
  func routeToPostPreview(_ promotionDraft: PromotionDraft) {
    let configurator = PostsFeedModuleConfigurator.previewPostPromotionConfig(AppModules.servicesContainer, promotionDraft)
    
    let module = AppModules
      .Posts
      .postsFeed(configurator.configFeedType)
      .build(configurator: configurator)
    
    module?.router.present(withPushfrom: presenter._viewController)
  }
}

// MARK: - CreatePromotionConfirm Viper Components
fileprivate extension CreatePromotionConfirmRouter {
  var presenter: CreatePromotionConfirmPresenterApi {
    return _presenter as! CreatePromotionConfirmPresenterApi
  }
}
