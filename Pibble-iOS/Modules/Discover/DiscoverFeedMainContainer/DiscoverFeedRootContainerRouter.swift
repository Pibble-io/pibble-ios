//
//  DiscoverFeedRootContainerRouter.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 18.12.2018.
//Copyright © 2018 com.kazai. All rights reserved.
//

import UIKit

// MARK: - DiscoverFeedRootContainerRouter class
final class DiscoverFeedRootContainerRouter: Router {
  fileprivate var preBuiltModules: [DiscoverFeedRootContainer.Segments: Module] = [:]
  
  fileprivate var currentPresentedModule: Module?
  fileprivate var discoverPostsModule: Module?
  fileprivate var currentModule: Module?
  fileprivate var searchHistoryModule: Module?
}

// MARK: - DiscoverFeedRootContainerRouter API
extension DiscoverFeedRootContainerRouter: DiscoverFeedRootContainerRouterApi {
  func routeToDiscoverPostsGrid(_ insideView: UIView) {
    guard let postsModule = discoverPostsModule else {
      let config: PostsFeed.FeedType = .discover
      let configurator = PostsFeedModuleConfigurator
        .discoverPostsGridContentConfig(AppModules.servicesContainer, config)
      discoverPostsModule = AppModules
        .Posts
        .postsFeed(config)
        .build(configurator: configurator)
      
      setupBottomModule(discoverPostsModule, container: insideView)
      return
    }
    
    setupBottomModule(postsModule, container: insideView)
  }
  
  func routeToSearchHistory(insideView: UIView, delegate: DiscoverSearchContentDelegate) -> DiscoverFeedRootContainerSearchDelegate? {
    guard let historyModule = searchHistoryModule else {
      let configurator = DiscoverSearchContentModuleConfigurator.searchHistory(AppModules.servicesContainer, delegate)
      
      let module = AppModules
        .Discover
        .discoverSearchContent(.top, delegate)
        .build(configurator: configurator)
      
      guard let moduleToBePresented = module else {
        return nil
      }
      
      searchHistoryModule = moduleToBePresented
      currentModule?.router.removeFromContainerView()
      currentModule = moduleToBePresented
      
      moduleToBePresented.router.show(from: presenter._viewController, insideView: insideView)
      return moduleToBePresented.presenter as? DiscoverFeedRootContainerSearchDelegate
    }
    
    searchHistoryModule = historyModule
    currentModule?.router.removeFromContainerView()
    currentModule = historyModule
    
    historyModule.router.show(from: presenter._viewController, insideView: insideView)
    return historyModule.presenter as? DiscoverFeedRootContainerSearchDelegate
  }
  
  func routeTo(_ segment: DiscoverFeedRootContainer.Segments, insideView: UIView, delegate: DiscoverSearchContentDelegate) -> DiscoverFeedRootContainerSearchDelegate? {
    guard let moduleToBePresented = getModuleFor(segment, delegate: delegate) else {
      return nil
    }
    
    currentModule?.router.removeFromContainerView()
    currentModule = moduleToBePresented
    moduleToBePresented.router.show(from: presenter._viewController, insideView: insideView)
    return moduleToBePresented.presenter as? DiscoverFeedRootContainerSearchDelegate
  }
}


// MARK: - DiscoverFeedRootContainer Viper Components
fileprivate extension DiscoverFeedRootContainerRouter {
    var presenter: DiscoverFeedRootContainerPresenterApi {
        return _presenter as! DiscoverFeedRootContainerPresenterApi
    }
}


extension DiscoverFeedRootContainerRouter {
  fileprivate func setupBottomModule(_ module: Module?, container: UIView) {
    currentPresentedModule?.router.removeFromContainerView()
    currentPresentedModule = module
    module?.router.show(from: presenter._viewController, insideView: container)
  }
}


fileprivate extension DiscoverFeedRootContainerRouter {
  func getModuleFor(_ segment: DiscoverFeedRootContainer.Segments, delegate: DiscoverSearchContentDelegate) -> Module? {
    if let builtModule = preBuiltModules[segment] {
      return builtModule
    }
    
    let moduleSetup = contentModuleFor(segment, delegate: delegate)
    guard let module = moduleSetup.build() else {
      return nil
    }
    
    preBuiltModules[segment] = module
    return module
  }
  
  fileprivate func contentModuleFor(_ segment: DiscoverFeedRootContainer.Segments, delegate: DiscoverSearchContentDelegate) -> ConfigurableModule {
    let content: DiscoverSearchContent.ContentType
    switch segment {
    case .top:
      content = .top
    case .users:
      content = .users
    case .places:
      content = .places
    case .tags:
      content = .tags
    }
    
    return AppModules
      .Discover
      .discoverSearchContent(content, delegate)
    
  }
}
