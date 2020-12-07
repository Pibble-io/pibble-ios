//
//  PromotedPostsContainerRouter.swift
//  Pibble-iOS
//
//  Created by Sergey Kazakov on 10/06/2019.
//Copyright © 2019 com.kazai. All rights reserved.
//

import UIKit

// MARK: - PromotedPostsContainerRouter class
final class PromotedPostsContainerRouter: Router {
  fileprivate var preBuiltModules: [PromotedPostsContainer.SelectedSegment: Module] = [:]
  fileprivate var currentModule: Module?

}


// MARK: - PromotedPostsContainerRouter API
extension PromotedPostsContainerRouter: PromotedPostsContainerRouterApi {
  func routeTo(_ segment: PromotedPostsContainer.SelectedSegment, accountProfile: AccountProfileProtocol, insideView: UIView) {
    guard let module = getModuleFor(segment, accountProfile: accountProfile) else {
      return
    }
    
    currentModule?.router.removeFromContainerView()
    currentModule = module
    module.router.show(from: presenter._viewController, insideView: insideView)
  }
  
  func getModuleFor(_ segment: PromotedPostsContainer.SelectedSegment, accountProfile: AccountProfileProtocol) -> Module? {
    if let builtModule = preBuiltModules[segment] {
      return builtModule
    }
    
    let module: Module?
    let promotionStatus: PromotionStatus
    switch segment {
    case .active:
      promotionStatus = .active
    case .pause:
      promotionStatus = .paused
    case .closed:
      promotionStatus = .closed
    }

    let config: PostsFeed.FeedType = .userPromotedPosts(accountProfile, promotionStatus)
    let configurator = PostsFeedModuleConfigurator.userPostsContentConfig(AppModules.servicesContainer,
                                                                   config)
    module = AppModules
      .Posts
      .postsFeed(config)
      .build(configurator: configurator)
    
    guard let builtModule = module else {
      return nil
    }
    
    preBuiltModules[segment] = builtModule
    return builtModule
  }
}

// MARK: - PromotedPostsContainer Viper Components
fileprivate extension PromotedPostsContainerRouter {
  var presenter: PromotedPostsContainerPresenterApi {
    return _presenter as! PromotedPostsContainerPresenterApi
  }
}
