//
//  AccountSettingsRouter.swift
//  Pibble-iOS
//
//  Created by Sergey Kazakov on 15/05/2019.
//Copyright © 2019 com.kazai. All rights reserved.
//

import Foundation

// MARK: - AccountSettingsRouter class
final class AccountSettingsRouter: Router {
}

// MARK: - AccountSettingsRouter API
extension AccountSettingsRouter: AccountSettingsRouterApi {
  func routeToAppLanguagePicker(_ delegate: LanguagePickerDelegateProtocol) {
    AppModules
      .Settings
      .languagePicker(delegate)
      .build()?
      .router.present(withPushfrom: presenter._viewController)
  }
  
  func routeToUsernamePicker() {
    AppModules
      .Settings
      .usernamePicker
      .build()?
      .router.present(withPushfrom: presenter._viewController)
  }
  
  func routeToMutedUsersListFor(_ user: UserProtocol) {
    AppModules
      .UserProfile
      .usersListing(.mutedUsers(user))
      .build()?
      .router.present(withPushfrom: presenter._viewController)
  }
}

// MARK: - AccountSettings Viper Components
fileprivate extension AccountSettingsRouter {
  var presenter: AccountSettingsPresenterApi {
    return _presenter as! AccountSettingsPresenterApi
  }
}
