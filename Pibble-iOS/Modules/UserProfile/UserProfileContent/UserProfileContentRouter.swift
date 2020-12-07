//
//  UserProfileContentRouter.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 05.11.2018.
//Copyright © 2018 com.kazai. All rights reserved.
//

import UIKit

// MARK: - UserProfileContentRouter class
final class UserProfileContentRouter: Router {
  fileprivate var mediaPickModule: Module?
}

// MARK: - UserProfileContentRouter API
extension UserProfileContentRouter: UserProfileContentRouterApi {
  func routeToPlayRoom(_ user: UserProtocol) {
    let targetUser: PlayRoom.PlayRoomType = (user.isCurrent ?? false) ? .currentUser : .otherUser(targetUser: user)
    
    let module = AppModules
      .UserProfile
      .playRoom(targetUser)
      .build()
    
    module?.router.presentFromRootWithPush()
  } 
  
  func routeToUserProfileURL(_ url: URL) {
    let configurator = ExternalLinkModuleConfigurator.modalConfig(url, url.absoluteString)
    let module = AppModules
      .Settings
      .externalLink(url, url.absoluteString)
      .build(configurator: configurator)
    
    module?.router.present(withDissolveFrom: presenter._viewController)
  }
  
  func routeToUserProfileFor(_ user: UserProtocol) {
    let targetUser: UserProfileContent.TargetUser = (user.isCurrent ?? false) ? .current : .other(user)
    
    AppModules
      .UserProfile
      .userProfileContainer(targetUser)
      .build()?
      .router.present(withPushfrom: presenter._viewController)
  }
  
  func routeToDescriptionPickWith(_ delegate: UserProfilePickDelegateProtocol) {
    AppModules
      .UserProfile
      .userDescriptionPicker(delegate)
      .build()?
      .router.present(withPushfrom: presenter._viewController, animated: true)
  }
  
  func routeToMediaPickWith(_ delegate: MediaPickDelegateProtocol) {
    mediaPickModule =
      AppModules
        .CreatePost
        .mediaPick(delegate, .singleImageItem)
        .build()
    
    
    mediaPickModule?.router.present(from: presenter._viewController)
  }
  
  func dismissMediaPick() {
    mediaPickModule?.router.dismiss()
  }
  
  func routeToFollowersFor(_ user: UserProtocol) {
    AppModules
      .UserProfile
      .usersListing(.followers(user))
      .build()?
      .router.present(withPushfrom: presenter._viewController, animated: true)
  }
  
  func routeToFollowingsFor(_ user: UserProtocol) {
    AppModules
      .UserProfile
      .usersListing(.following(user))
      .build()?
      .router.present(withPushfrom: presenter._viewController, animated: true)
  }
  
  func routeToFriendsFor(_ user: UserProtocol) {
    AppModules
      .UserProfile
      .usersListing(.friends(user))
      .build()?
      .router.present(withPushfrom: presenter._viewController, animated: true)
  }
  
  func routeToPostingsFor(_ user: UserProtocol) {
    let config = PostsFeed.FeedType.userPosts(user)
    let configurator = PostsFeedModuleConfigurator.userPostsConfig(AppModules.servicesContainer, config, shouldScrollToPost: nil)
    AppModules
      .Posts
      .postsFeed(config)
      .build(configurator: configurator)?
      .router.present(withPushfrom: presenter._viewController)
  }
  
}

// MARK: - UserProfileContent Viper Components
fileprivate extension UserProfileContentRouter {
    var presenter: UserProfileContentPresenterApi {
        return _presenter as! UserProfileContentPresenterApi
    }
}
