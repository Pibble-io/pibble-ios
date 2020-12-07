//
//  FundingPostsContainerRouter.swift
//  Pibble-iOS
//
//  Created by Sergey Kazakov on 10/06/2019.
//Copyright © 2019 com.kazai. All rights reserved.
//

import UIKit

// MARK: - FundingPostsContainerRouter class
final class FundingPostsContainerRouter: Router {
  fileprivate var preBuiltModules: [FundingPostsContainer.SelectedSegment: Module] = [:]
  fileprivate var currentModule: Module?

}


// MARK: - FundingPostsContainerRouter API
extension FundingPostsContainerRouter: FundingPostsContainerRouterApi {
  func routeTo(_ segment: FundingPostsContainer.SelectedSegment, accountProfile: AccountProfileProtocol, insideView: UIView) {
    guard let module = getModuleFor(segment, accountProfile: accountProfile) else {
      return
    }
    
    currentModule?.router.removeFromContainerView()
    currentModule = module
    module.router.show(from: presenter._viewController, insideView: insideView)
  }
  
  func getModuleFor(_ segment: FundingPostsContainer.SelectedSegment, accountProfile: AccountProfileProtocol) -> Module? {
    if let builtModule = preBuiltModules[segment] {
      return builtModule
    }
    
    let module: Module?
    
    let config: PostsFeed.FeedType
    
    switch segment {
    case .active:
      config = .currentUserActiveFundingPosts(accountProfile)
    case .ended:
      config = .currentUserEndedFundingPosts(accountProfile)
    case .backer:
      config = .currentUserBackedFundingPosts(accountProfile)
    }
   
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

// MARK: - FundingPostsContainer Viper Components
fileprivate extension FundingPostsContainerRouter {
  var presenter: FundingPostsContainerPresenterApi {
    return _presenter as! FundingPostsContainerPresenterApi
  }
}
