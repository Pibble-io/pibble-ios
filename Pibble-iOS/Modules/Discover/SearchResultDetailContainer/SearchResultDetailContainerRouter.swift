//
//  SearchResultDetailContainerRouter.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 27.12.2018.
//Copyright © 2018 com.kazai. All rights reserved.
//

import UIKit

// MARK: - SearchResultDetailContainerRouter class
final class SearchResultDetailContainerRouter: Router {
  fileprivate var currentPresentedModuleInBottomContaier: Module?
}

// MARK: - SearchResultDetailContainerRouter API
extension SearchResultDetailContainerRouter: SearchResultDetailContainerRouterApi {
  func presentTagDetail(_ container: UIView, for tag: TagProtocol) {
    let module = AppModules
                  .Discover
                  .searchResultTagDetailContent(tag)
                  .build()
    
    module?.router.show(from: presenter._viewController, insideView: container)
    
    let viewController = presenter._viewController as? SearchResultDetailContainerViewControllerApi
    viewController?.topSectionEmbeddableViewController = module?.presenter._viewController as? EmbedableViewController
  }
  
  func presentPlaceDetail(_ container: UIView, for place: LocationProtocol) {
    let config = place
    let configurator = SearchResultPlaceMapModuleConfigurator.searchResultPlaceMapContent(config)
    
    let module = AppModules
      .Discover
      .searchResultPlaceMap(config)
      .build(configurator: configurator)
    
    module?.router.show(from: presenter._viewController, insideView: container)
    
    let viewController = presenter._viewController as? SearchResultDetailContainerViewControllerApi
    viewController?.topSectionEmbeddableViewController = module?.presenter._viewController as? EmbedableViewController
  }
  
  
  func presentPostsIn(_ container: UIView, for tag: TagProtocol) {
    let config: PostsFeed.FeedType = .postsRelatedToTag(tag)
    let configurator = PostsFeedModuleConfigurator.userPostsBaseContentConfig(AppModules.servicesContainer, config)
    let userPostsModule = AppModules
      .Posts
      .postsFeed(config)
      .build(configurator: configurator)
    
    setupBottomModule(userPostsModule, container: container)
  }
  
  func presentPostsGridIn(_ container: UIView, for tag: TagProtocol) {
    let config: PostsFeed.FeedType = .postsRelatedToTag(tag)
    let configurator = PostsFeedModuleConfigurator.userPostsGridContentConfig(AppModules.servicesContainer, config)
    let userPostsModule = AppModules
      .Posts
      .postsFeed(config)
      .build(configurator: configurator)
    
    setupBottomModule(userPostsModule, container: container)
  }
  
  func presentPostsIn(_ container: UIView, for place: LocationProtocol) {
    let config: PostsFeed.FeedType = .postsRelatedToPlace(place)
    let configurator = PostsFeedModuleConfigurator.userPostsBaseContentConfig(AppModules.servicesContainer, config)
    let userPostsModule = AppModules
      .Posts
      .postsFeed(config)
      .build(configurator: configurator)
    
    setupBottomModule(userPostsModule, container: container)
  }
  
  func presentPostsGridIn(_ container: UIView, for place: LocationProtocol) {
    let config: PostsFeed.FeedType = .postsRelatedToPlace(place)
    let configurator = PostsFeedModuleConfigurator.userPostsGridContentConfig(AppModules.servicesContainer, config)
    let userPostsModule = AppModules
      .Posts
      .postsFeed(config)
      .build(configurator: configurator)
    
    setupBottomModule(userPostsModule, container: container)
  }
  
  func removeBottomContainer() {
    currentPresentedModuleInBottomContaier?.router.removeFromContainerView()
    currentPresentedModuleInBottomContaier = nil
  }
  
  func presentUserPostsGridIn(_ container: UIView, user: UserProtocol) {
    let config: PostsFeed.FeedType = .userPosts(user)
    let configurator = PostsFeedModuleConfigurator.userPostsGridContentConfig(AppModules.servicesContainer, config)
    let userPostsModule = AppModules
      .Posts
      .postsFeed(config)
      .build(configurator: configurator)
    
    setupBottomModule(userPostsModule, container: container)
  }
}

// MARK: - UserProfileContainer Viper Components
fileprivate extension SearchResultDetailContainerRouter {
  var presenter: SearchResultDetailContainerPresenterApi {
    return _presenter as! SearchResultDetailContainerPresenterApi
  }
}

//MARK:- Helpers

extension SearchResultDetailContainerRouter {
  fileprivate func setupBottomModule(_ module: Module?, container: UIView) {
    currentPresentedModuleInBottomContaier?.router.removeFromContainerView()
    currentPresentedModuleInBottomContaier = module
    module?.router.show(from: presenter._viewController, insideView: container)
    
    let viewController = presenter._viewController as? SearchResultDetailContainerViewControllerApi
    viewController?.bottmoSectionEmbeddableViewController = module?.presenter._viewController as? EmbedableViewController
  }
}

