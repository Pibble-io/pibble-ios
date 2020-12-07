//
//  UserProfileContainerRouter.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 05.11.2018.
//Copyright © 2018 com.kazai. All rights reserved.
//

import UIKit

// MARK: - UserProfileContainerRouter class
final class UserProfileContainerRouter: Router {
  fileprivate var currentPresentedModuleInBottomContaier: Module?
}

// MARK: - UserProfileContainerRouter API
extension UserProfileContainerRouter: UserProfileContainerRouterApi {
  func routeToLogin() {
    if let module = AppModules.Auth.signIn.build(),
      let window = UIApplication.shared.delegate?.window {
      module.router.show(inWindow: window, embedInNavController: true, animated: true)
    }
  }
  
  func presentBannedUserProfileIn(_ container: UIView, user: UserProtocol) {
    AppModules
      .UserProfile
      .bannedUserProfileContent(user)
      .build()?
      .router.show(from: presenter._viewController, insideView: container)
  }
  
  func routeToChatRoomForPost(_ user: UserProtocol) {
    AppModules
      .Messenger
      .chat(.roomForUser([user]))
      .build()?
      .router.presentFromRootWithPush()
  }
  
  func routeToChatRooms() {
    let module = AppModules
      .Messenger
      .chatRoomsContainer
      .build()
    
    module?.router.presentFromRootWithPush()
  }
  
  func routeToSettings() {
    let module = AppModules
      .Settings
      .settingsHome
      .build()
    
    module?.router.presentFromRootWithPush()
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
  
  func presentUserFavoritesPostsIn(_ container: UIView, user: UserProtocol) {
    let config: PostsFeed.FeedType = .favoritesPosts(user)
    let configurator = PostsFeedModuleConfigurator.userPostsGridContentConfig(AppModules.servicesContainer, config)
    let userPostsModule = AppModules
      .Posts
      .postsFeed(config)
      .build(configurator: configurator)
    
    setupBottomModule(userPostsModule, container: container)
  }
  
  func presentUserBrushedPostsIn(_ container: UIView, user: UserProtocol) {
    let config: PostsFeed.FeedType = .upvotedPosts(user)
    let configurator = PostsFeedModuleConfigurator.userPostsGridContentConfig(AppModules.servicesContainer, config)
    let userPostsModule = AppModules
      .Posts
      .postsFeed(config)
      .build(configurator: configurator)
    
    setupBottomModule(userPostsModule, container: container)
  }
  
  func presentUserPostsIn(_ container: UIView, user: UserProtocol) {
    let config: PostsFeed.FeedType = .userPosts(user)
    let configurator = PostsFeedModuleConfigurator.userPostsBaseContentConfig(AppModules.servicesContainer, config)
    let userPostsModule = AppModules
      .Posts
      .postsFeed(config)
      .build(configurator: configurator)
    
    setupBottomModule(userPostsModule, container: container)
  }
  
  func presentUserProfileIn(_ container: UIView, targetUser: UserProfileContent.TargetUser) {
    let userProfileModule =
      AppModules
      .UserProfile
      .userProfileContent(targetUser)
      .build()
    
    userProfileModule?.router.show(from: presenter._viewController, insideView: container)
    
    let viewController = presenter._viewController as? UserProfileContainerViewControllerApi
    viewController?.topSectionEmbeddableViewController = userProfileModule?.presenter._viewController as? EmbedableViewController
  }
}

// MARK: - UserProfileContainer Viper Components
fileprivate extension UserProfileContainerRouter {
    var presenter: UserProfileContainerPresenterApi {
        return _presenter as! UserProfileContainerPresenterApi
    }
}

//MARK:- Helpers

extension UserProfileContainerRouter {
  fileprivate func setupBottomModule(_ module: Module?, container: UIView) {
    currentPresentedModuleInBottomContaier?.router.removeFromContainerView()
    currentPresentedModuleInBottomContaier = module
    module?.router.show(from: presenter._viewController, insideView: container)
    
    let viewController = presenter._viewController as? UserProfileContainerViewControllerApi
    viewController?.bottmoSectionEmbeddableViewController = module?.presenter._viewController as? EmbedableViewController
  }
}
