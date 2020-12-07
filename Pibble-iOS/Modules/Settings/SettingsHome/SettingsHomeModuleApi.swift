//
//  SettingsHomeModuleApi.swift
//  Pibble-iOS
//
//  Created by Sergey Kazakov on 15/05/2019.
//Copyright © 2019 com.kazai. All rights reserved.
//

import UIKit

//MARK: - SettingsHomeRouter API
protocol SettingsHomeRouterApi: RouterProtocol {
  func routeToLogin() 
  func routeToEditFriendsListFor(_ user: UserProtocol)
  func routeToInviteFriendsForCurrentUser(_ user: AccountProfileProtocol)
  func routeToCommerce()
  func routeToPromotionsFor(_ accountProfile: AccountProfileProtocol)
  func routeToFundingsFor(_ accountProfile: AccountProfileProtocol)
  func routeToAccountSettings()
  func routeToWalletSettings()
  func routeToAboutScreen()
}

//MARK: - SettingsHomeView API
protocol SettingsHomeViewControllerApi: ViewControllerProtocol {
}

//MARK: - SettingsHomePresenter API
protocol SettingsHomePresenterApi: PresenterProtocol {
  func handleHideAction()
  
  func numberOfSections() -> Int
  func numberOfItemsInSection(_ section: Int) -> Int
  func itemViewModelAt(_ indexPath: IndexPath) -> SettingsHomeItemViewModelProtocol
  func handleSelectionAt(_ indexPath: IndexPath)
  
  func presentFriendsForUser(_ user: UserProtocol)
  func presentInviteFriendsForUser(_ user: AccountProfileProtocol)
  
  func presentPromotionsForUser(_ user: AccountProfileProtocol)
  func presentFundingsForUser(_ user: AccountProfileProtocol)
}

//MARK: - SettingsHomeInteractor API
protocol SettingsHomeInteractorApi: InteractorProtocol {  
  func performFetchCurrentUserAndPresentEditFriends()
  func performFetchCurrentUserAndPresentInviteFriends()
  func performFetchCurrentUserAndPresentPromotions()
  func performFetchCurrentUserAndPresentFundings() 
  func performLogout()
}


protocol SettingsHomeItemViewModelProtocol {
  var title: String { get }
  var icon: UIImage { get }
  var isUpperSeparatorVisible: Bool { get }
  var isRightArrowVisible: Bool { get }
  var titleColor: UIColor { get }
}

