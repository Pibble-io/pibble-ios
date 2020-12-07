//
//  SettingsHomeRouter.swift
//  Pibble-iOS
//
//  Created by Sergey Kazakov on 15/05/2019.
//Copyright © 2019 com.kazai. All rights reserved.
//

import UIKit

// MARK: - SettingsHomeRouter class
final class SettingsHomeRouter: Router {
}

// MARK: - SettingsHomeRouter API
extension SettingsHomeRouter: SettingsHomeRouterApi {
  func routeToFundingsFor(_ accountProfile: AccountProfileProtocol) {
    AppModules
      .Posts
      .fundingPostsContainer(accountProfile)
      .build()?
      .router.present(withPushfrom: presenter._viewController)
  }
  
  func routeToPromotionsFor(_ accountProfile: AccountProfileProtocol) {
    AppModules
      .Promotion
      .promotedPostsContainer(accountProfile)
      .build()?
      .router.present(withPushfrom: presenter._viewController)
  }
  
  func routeToLogin() {
    if let module = AppModules.Auth.signIn.build(),
      let window = UIApplication.shared.delegate?.window {
      module.router.show(inWindow: window, embedInNavController: true, animated: true)
    }
  }
  
  func routeToAboutScreen() {
    AppModules
      .Settings
      .about
      .build()?
      .router.present(withPushfrom: presenter._viewController)
  }
  
  func routeToWalletSettings() {
    AppModules
      .Settings
      .walletSettings
      .build()?
      .router.present(withPushfrom: presenter._viewController)
  }
  
  func routeToEditFriendsListFor(_ user: UserProtocol) {
    AppModules
      .UserProfile
      .usersListing(.editFriends(user))
      .build()?
      .router.present(withPushfrom: presenter._viewController)
  }
  
  func routeToInviteFriendsForCurrentUser(_ user: AccountProfileProtocol) {
    AppModules
      .Gifts
      .giftsInvite
      .build()?
      .router.present(withPushfrom: presenter._viewController)
  }
  
  func routeToCommerce() {
    AppModules
      .Settings
      .commerceTypePick
      .build()?
      .router.present(withPushfrom: presenter._viewController)
  }
  
  func routeToAccountSettings() {
    AppModules
      .Settings
      .accountSettings
      .build()?
      .router.present(withPushfrom: presenter._viewController)
  }
}

// MARK: - SettingsHome Viper Components
fileprivate extension SettingsHomeRouter {
  var presenter: SettingsHomePresenterApi {
    return _presenter as! SettingsHomePresenterApi
  }
}
