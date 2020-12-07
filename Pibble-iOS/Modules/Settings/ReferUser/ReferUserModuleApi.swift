//
//  ReferUserModuleApi.swift
//  Pibble-iOS
//
//  Created by Sergey Kazakov on 17/05/2019.
//Copyright © 2019 com.kazai. All rights reserved.
//

import UIKit

//MARK: - ReferUserRouter API
protocol ReferUserRouterApi: RouterProtocol {
  func routeToShareControl(_ text: String)
}

//MARK: - ReferUserView API
protocol ReferUserViewControllerApi: ViewControllerProtocol {
  func setReferralInfoViewModel(_ vm: ReferralInfoViewModelProtocol)
  func setReferralUserId(_ referralId: String, isEnabled: Bool)
  func showReferralUserRegistrationSuccessAlertWith(_ message: String)
  
  func updateCollection(_ updates: CollectionViewModelUpdate)
  func reloadData()
}

//MARK: - ReferUserPresenter API
protocol ReferUserPresenterApi: PresenterProtocol {
  var hasRegisteredUsers: Bool { get }
  
  func handleHideAction()
  
  func handleCopyAction()
  func handleInviteAction()
  func handleRegisterAction()
  
  func handleRegisteredUsernameChange(_ text: String)

  func numberOfSections() -> Int
  func numberOfItemsInSection(_ section: Int) -> Int
  func itemViewModelAt(_ indexPath: IndexPath) -> ReferredUserViewModelProtocol
  
  func handleWillDisplayItem(_ indexPath: IndexPath)
  func handleDidEndDisplayItem(_ indexPath: IndexPath)
  
  func presentCollectionUpdates(_ updates: CollectionViewModelUpdate)
  func presentReload()
  func presentReferralOwnerUserId(_ user: String?)
  func presentReferralInfo(_ referralBonus: ReferralBonus, forCurrentUser: AccountProfileProtocol)
  func presentReferralUserRegistrationSuccessWith(_ referralBonus: ReferralBonus)
}

//MARK: - ReferUserInteractor API
protocol ReferUserInteractorApi: InteractorProtocol {
  var currentUser: AccountProfileProtocol { get }
  func updateRegistrationUserName(_ text: String)
  func performReferralUserRegistration()
  
  func initialFetchData()
  func initialRefresh() 

  func numberOfSections() -> Int
  func numberOfItemsInSection(_ section: Int) -> Int
  func itemAt(_ indexPath: IndexPath) -> UserProtocol
  
  func prepareItemFor(_ indexPath: Int)
  func cancelPrepareItemFor(_ indexPath: Int)
}


protocol ReferralInfoViewModelProtocol {
  var headerTitle: String { get }
  var headerSubtitle: String { get }
  var inviteAmount: String { get }
  var inviteReferralId: String { get }
  
}

protocol ReferredUserViewModelProtocol {
  var userpicUrlString: String { get }
  var usrepicPlaceholder: UIImage? { get }
  var username: String { get }
}
