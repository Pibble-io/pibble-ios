//
//  AccountSettingsPresenter.swift
//  Pibble-iOS
//
//  Created by Sergey Kazakov on 15/05/2019.
//Copyright © 2019 com.kazai. All rights reserved.
//

import Foundation

// MARK: - AccountSettingsPresenter Class
final class AccountSettingsPresenter: Presenter {
  fileprivate var sections: [(section: AccountSettingsSections, items: [AccountSettings.SettingsItems])] =  [
    (section: .commerceTypes, items: [.language, .username, .mutedUsers])
  ]
}

//MARK:- Helpers
extension AccountSettingsPresenter {
  fileprivate func itemAt(indexPath: IndexPath) -> AccountSettings.SettingsItems {
    return sections[indexPath.section].items[indexPath.item]
  }
}

extension AccountSettingsPresenter: LanguagePickerDelegateProtocol {
  func didSelectAppLanguage(_ language: AppLanguage) {
    interactor.appLanguageSettings = language
  }
  
  func selectedAppLanguage() -> AppLanguage? {
    return interactor.appLanguageSettings
  }
}


// MARK: - AccountSettingsPresenter API
extension AccountSettingsPresenter: AccountSettingsPresenterApi {
  func presentMutedUsersForUser(_ user: UserProtocol) {
    router.routeToMutedUsersListFor(user)
  }
  
  func numberOfSections() -> Int {
    return sections.count
  }
  
  func numberOfItemsInSection(_ section: Int) -> Int {
    return sections[section].items.count
  }
  
  func itemViewModelAt(_ indexPath: IndexPath) -> AccountSettingsItemViewModelProtocol {
    let settingsItem = itemAt(indexPath: indexPath)
    let shouldHaveUpperSeparator = indexPath.section != 0 && indexPath.item == 0
    return AccountSettings.AccountSettingsItemViewModel(settingsItem: settingsItem,
                                                  shouldHaveUpperSeparator: shouldHaveUpperSeparator)
  }
  
  func handleSelectionAt(_ indexPath: IndexPath) {
    let item = itemAt(indexPath: indexPath)
    switch item {
    case .language:
      router.routeToAppLanguagePicker(self)
    case .username:
      router.routeToUsernamePicker()
    case .mutedUsers:
      interactor.performFetchCurrentUserAndPresentMutedUsers()
    }
  }
  
  func handleHideAction() {
    router.dismiss()
  }
}

// MARK: - AccountSettings Viper Components
fileprivate extension AccountSettingsPresenter {
  var viewController: AccountSettingsViewControllerApi {
    return _viewController as! AccountSettingsViewControllerApi
  }
  var interactor: AccountSettingsInteractorApi {
    return _interactor as! AccountSettingsInteractorApi
  }
  var router: AccountSettingsRouterApi {
    return _router as! AccountSettingsRouterApi
  }
}

fileprivate enum AccountSettingsSections {
  case commerceTypes
}

