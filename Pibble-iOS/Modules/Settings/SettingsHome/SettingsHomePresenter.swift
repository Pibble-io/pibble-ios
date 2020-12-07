//
//  SettingsHomePresenter.swift
//  Pibble-iOS
//
//  Created by Sergey Kazakov on 15/05/2019.
//Copyright © 2019 com.kazai. All rights reserved.
//

import Foundation

// MARK: - SettingsHomePresenter Class
final class SettingsHomePresenter: Presenter {
  
  fileprivate var sections: [(section: SettingsHomeSections, items: [SettingsHome.SettingsItems])] =  [
    (section: .settings, items: SettingsHome.SettingsItems.settings),
    (section: .actions, items: SettingsHome.SettingsItems.actions)
  ]
}

//MARK:- Helpers
extension SettingsHomePresenter {
  fileprivate func itemAt(indexPath: IndexPath) -> SettingsHome.SettingsItems {
    return sections[indexPath.section].items[indexPath.item]
  }
}


// MARK: - SettingsHomePresenter API
extension SettingsHomePresenter: SettingsHomePresenterApi {
  func presentInviteFriendsForUser(_ user: AccountProfileProtocol) {
    router.routeToInviteFriendsForCurrentUser(user)
  }
  
  func presentFriendsForUser(_ user: UserProtocol) {
    router.routeToEditFriendsListFor(user)
  }
  
  func presentPromotionsForUser(_ user: AccountProfileProtocol) {
    router.routeToPromotionsFor(user)
  }
  
  func presentFundingsForUser(_ user: AccountProfileProtocol) {
    router.routeToFundingsFor(user)
  }
  
  func numberOfSections() -> Int {
    return sections.count
  }
  
  func numberOfItemsInSection(_ section: Int) -> Int {
    return sections[section].items.count
  }
  
  func itemViewModelAt(_ indexPath: IndexPath) -> SettingsHomeItemViewModelProtocol {
    let settingsItem = itemAt(indexPath: indexPath)
    let shouldHaveUpperSeparator = indexPath.section != 0 && indexPath.item == 0
    return SettingsHome.SettingsHomeItemViewModel(settingsItem: settingsItem,
                                                  shouldHaveUpperSeparator: shouldHaveUpperSeparator)
  }
  
  func handleSelectionAt(_ indexPath: IndexPath) {
    let settingsItem = itemAt(indexPath: indexPath)
    switch settingsItem {
    case .inviteFriends:
      interactor.performFetchCurrentUserAndPresentInviteFriends()
    case .closeFriends:
      interactor.performFetchCurrentUserAndPresentEditFriends()
    case .notifications:
      break
    case .commerce:
      router.routeToCommerce()
    case .promotions:
      interactor.performFetchCurrentUserAndPresentPromotions()
    case .funding:
      interactor.performFetchCurrentUserAndPresentFundings()
    case .wallet:
      router.routeToWalletSettings()
    case .account:
      router.routeToAccountSettings()
    case .help:
      break
    case .about:
      router.routeToAboutScreen()
    case .logout:
      interactor.performLogout()
      router.routeToLogin()
    }
  }
  
  func handleHideAction() {
    router.dismiss()
  }
}

// MARK: - SettingsHome Viper Components
fileprivate extension SettingsHomePresenter {
  var viewController: SettingsHomeViewControllerApi {
    return _viewController as! SettingsHomeViewControllerApi
  }
  var interactor: SettingsHomeInteractorApi {
    return _interactor as! SettingsHomeInteractorApi
  }
  var router: SettingsHomeRouterApi {
    return _router as! SettingsHomeRouterApi
  }
}

fileprivate enum SettingsHomeSections {
  case settings
  case actions
}

extension SettingsHome.SettingsItems {
  static let settings: [SettingsHome.SettingsItems] = [
    .inviteFriends,
    .closeFriends,
    .commerce,
    .promotions,
    .funding,
    .wallet,
    .account,
    .about
  ]
//  static let settings: [SettingsHome.SettingsItems] = Array(SettingsHome.SettingsItems.inviteFriends.rawValue...SettingsHome.SettingsItems.about.rawValue)
//    .map { return SettingsHome.SettingsItems(rawValue: $0)! }
  
  static let actions: [SettingsHome.SettingsItems] = [.logout]
}

