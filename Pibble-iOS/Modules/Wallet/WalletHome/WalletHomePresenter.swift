//
//  WalletHomePresenter.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 23.08.2018.
//Copyright © 2018 com.kazai. All rights reserved.
//

import UIKit

// MARK: - WalletHomePresenter Class
final class WalletHomePresenter: WalletPinCodeSecuredPresenter {
  fileprivate let actions: [[WalletHome.RouteActions]] = [[.recieve, .send, .payBill, .exchange, .activity, .market]]
  
  fileprivate var profileViewModel: WalletHomeDashboardViewModelProtocol?

  override var shouldLockOnFirstAppearance: Bool {
    return true
  }
  
  override func viewWillAppear() {
    super.viewWillAppear()
    presentUserProfile(interactor.userProfile, animated: false)
    interactor.fetchInitialData()
  }
  
  override func viewDidAppear() {
    super.viewDidAppear()
  }
  
  fileprivate func presentUserProfile(_ profile: UserProtocol?, animated: Bool) {
    if _viewController == nil {
      return
    }
    
    guard let profile = profile else {
      viewController.setProfile(nil, animated: animated)
      return
    }
    
    profileViewModel = WalletHome.UserProfileViewModel(userProfile: profile)
    viewController.reloadData()
    viewController.setProfile(profileViewModel, animated: animated)
  }
}

// MARK: - WalletHomePresenter API
extension WalletHomePresenter: WalletHomePresenterApi {
  func presentUserProfile(_ profile: UserProtocol) {
    presentUserProfile(profile, animated: true)
  }
  
  func handeHideAction() {
    router.dismiss()
  }
  
  func numberOfSections() -> Int {
    return actions.count
  }
  
  func handleSelectionAt(_ indexPath: IndexPath) {
    let item = actions[indexPath.section][indexPath.item]
    guard let profile = interactor.userProfile else {
      return
    }
    router.routeTo(item, accountProfile: profile)
  }
  
  func numberOfItemsInSection(_ section: Int) -> Int {
    return actions[section].count
  }
  
  func itemAt(_ indexPath: IndexPath) -> WalletHomeActionViewModelProtocol {
    let action =  actions[indexPath.section][indexPath.item]
    let viewModel = WalletHome.ActionViewModel(action: action, currentUser: interactor.userProfile)
    return viewModel
  }
  
  func itemHeaderAt(_ section: Int) -> WalletHomeDashboardViewModelProtocol? {
    return profileViewModel
  }
  
  func handleAction(_ action: WalletHome.RouteActions) {
    guard let profile = interactor.userProfile else {
      return
    }
    router.routeTo(action, accountProfile: profile)
  }
}

// MARK: - WalletHome Viper Components
fileprivate extension WalletHomePresenter {
  var viewController: WalletHomeViewControllerApi {
    return _viewController as! WalletHomeViewControllerApi
  }
  var interactor: WalletHomeInteractorApi {
    return _interactor as! WalletHomeInteractorApi
  }
  var router: WalletHomeRouterApi {
    return _router as! WalletHomeRouterApi
  }
}


