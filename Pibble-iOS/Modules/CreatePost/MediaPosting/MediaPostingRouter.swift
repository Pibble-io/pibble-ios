//
//  MediaPostingRouter.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 13.07.2018.
//Copyright © 2018 com.kazai. All rights reserved.
//

import Foundation

// MARK: - MediaPostingRouter class
final class MediaPostingRouter: Router {
}

// MARK: - MediaPostingRouter API
extension MediaPostingRouter: MediaPostingRouterApi {
  func routeToCampaignPick(_ postDraft: MutablePostDraftProtocol, campaignType: CampaignType) {
    let module = AppModules
      .CreatePost
      .campaignPick(postDraft, campaignType)
      .build()
      
    module?.view.transitionsController.presentationAnimator = FadeAnimationController(presenting: true)
    module?.view.transitionsController.dismissalAnimator = FadeAnimationController(presenting: false)
    module?.router.present(withPushfrom: presenter._viewController)
  }
  
  func routeToCampaignEdit(_ postDraft: MutablePostDraftProtocol, campaignType: CampaignType) {
    let module = AppModules
      .CreatePost
      .campaignEdit(postDraft, campaignType)
      .build()
      
    module?.view.transitionsController.presentationAnimator = FadeAnimationController(presenting: true)
    module?.view.transitionsController.dismissalAnimator = FadeAnimationController(presenting: false)
    module?.router.present(withPushfrom: presenter._viewController)
  }
  
  func routeToTagPick(_ withDelegate: TagPickDelegateProtocol) {
    AppModules
      .CreatePost
      .tagPick(withDelegate)
      .build()?
      .router.present(withPushfrom: presenter._viewController)
  }
  
  func routeToLocationPick(_ withDelegate: LocationPickDelegateProtocol) {
    AppModules
      .CreatePost
      .locationPick(withDelegate)
      .build()?
      .router.present(withPushfrom: presenter._viewController)
  }
  
  func routeToDescriptionPick(_ withDelegate: DescriptionPickDelegateProtocol) {
    AppModules
      .CreatePost
      .descriptionPick(withDelegate)
      .build()?
      .router.present(withPushfrom: presenter._viewController)
  }
  
  func routeToPromotionPick(_ withDelegate: PromotionPickDelegateProtocol) {
    AppModules
      .CreatePost
      .promotionPick(withDelegate)
      .build()?
      .router.present(withPushfrom: presenter._viewController)
  }
}

// MARK: - MediaPosting Viper Components
fileprivate extension MediaPostingRouter {
    var presenter: MediaPostingPresenterApi {
        return _presenter as! MediaPostingPresenterApi
    }
}
