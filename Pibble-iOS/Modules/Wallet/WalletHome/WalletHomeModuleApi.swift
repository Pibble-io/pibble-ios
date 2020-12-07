//
//  WalletHomeModuleApi.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 23.08.2018.
//Copyright © 2018 com.kazai. All rights reserved.
//

import UIKit

//MARK: - WalletHomeRouter API
protocol WalletHomeRouterApi: WalletPinCodeSecuredRouterProtocol {
  func routeTo(_ route: WalletHome.RouteActions, accountProfile: AccountProfileProtocol)
  func routeToPinCodeRegistration(delegate: WalletPinCodeUnlockDelegateProtocol)
  func routeToPinCodeUnlock(delegate: WalletPinCodeUnlockDelegateProtocol)
}

//MARK: - WalletHomeView API
protocol WalletHomeViewControllerApi: ViewControllerProtocol {
  func reloadData()
  func setProfile(_ vm: WalletProfileHeaderViewModelProtocol?, animated: Bool)
}

//MARK: - WalletHomePresenter API
protocol WalletHomePresenterApi: PresenterProtocol {
  func handleSelectionAt(_ indexPath: IndexPath)
  func handeHideAction()
  
  func numberOfItemsInSection(_ section: Int) -> Int
  func numberOfSections() -> Int
  func itemAt(_ indexPath: IndexPath) -> WalletHomeActionViewModelProtocol
  func itemHeaderAt(_ section: Int) -> WalletHomeDashboardViewModelProtocol?
  func presentUserProfile(_ profile: UserProtocol)
}

//MARK: - WalletHomeInteractor API

protocol WalletHomeInteractorApi: InteractorProtocol {
  var userProfile: AccountProfileProtocol? { get }
  
  func fetchInitialData()
  var hasPinCode: Bool { get }
}

protocol WalletHomeDashboardViewModelProtocol: WalletProfileHeaderViewModelProtocol {
  var balances: [(currency: String, balance: String)] { get }
}

protocol WalletHomeActionViewModelProtocol {
  var image: UIImage { get }
  var title: String { get }
  var badgeTitle: String? { get }
}

