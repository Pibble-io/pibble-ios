//
//  ReferUserPresenter.swift
//  Pibble-iOS
//
//  Created by Sergey Kazakov on 17/05/2019.
//Copyright © 2019 com.kazai. All rights reserved.
//

import UIKit

// MARK: - ReferUserPresenter Class
final class ReferUserPresenter: Presenter {
  override func viewDidLoad() {
    super.viewDidLoad()
    interactor.initialFetchData()
  }
  
  override func viewWillAppear() {
    super.viewWillAppear()
    interactor.initialRefresh()
  }
}

// MARK: - ReferUserPresenter API
extension ReferUserPresenter: ReferUserPresenterApi {
  func presentReferralUserRegistrationSuccessWith(_ referralBonus: ReferralBonus) {
    let inviteValue = String(format: "%.0f", referralBonus.inviteReferralBonus.value)
    let inviteString = "\(inviteValue) \(referralBonus.inviteReferralBonus.currency.symbol)"
    
    let registrationValue = String(format: "%.0f", referralBonus.registrationBonus.value)
    let registrationString = "\(registrationValue) \(referralBonus.registrationBonus.currency.symbol)"
    
    let message = ReferUser.Strings.referralRegistrationSuccess.localize(values: registrationString, inviteString)
    
    viewController.showReferralUserRegistrationSuccessAlertWith(message)
  }
  
  var hasRegisteredUsers: Bool {
    var hasItems = false
    Array(0..<interactor.numberOfSections()).forEach {
      if interactor.numberOfItemsInSection($0) > 0 {
        hasItems = true
      }
    }
    
    return hasItems
  }
  
  func presentReferralOwnerUserId(_ referralOwnerUserId: String?) {
    viewController.setReferralUserId(referralOwnerUserId ?? "", isEnabled: referralOwnerUserId == nil)
  }
  
  func presentReferralInfo(_ referralBonus: ReferralBonus, forCurrentUser: AccountProfileProtocol) {
    let viewModel = ReferUser.ReferralInfoViewModel(referralBonus: referralBonus, currentUser: forCurrentUser)
    viewController.setReferralInfoViewModel(viewModel)
  }
  
  func handleHideAction() {
    router.dismiss()
  }
  
  func handleCopyAction() {
    UIPasteboard.general.string = interactor.currentUser.referralCode
  }
  
  func handleInviteAction() {
    let inviteString = ReferUser.Strings.shareTitle.localize(value: interactor.currentUser.referralCode)
    router.routeToShareControl(inviteString)
  }
  
  func handleRegisterAction() {
    interactor.performReferralUserRegistration()
  }
  
  func handleRegisteredUsernameChange(_ text: String) {
    interactor.updateRegistrationUserName(text)
  }
  
  func numberOfSections() -> Int {
    return interactor.numberOfSections()
  }
  
  func numberOfItemsInSection(_ section: Int) -> Int {
    return interactor.numberOfItemsInSection(section)
  }
  
  func itemViewModelAt(_ indexPath: IndexPath) -> ReferredUserViewModelProtocol {
    let item = interactor.itemAt(indexPath)
    return ReferUser.ReferredUserViewModel(user: item)
  }
  
  func handleWillDisplayItem(_ indexPath: IndexPath) {
    interactor.prepareItemFor(indexPath.item)
  }
  
  func handleDidEndDisplayItem(_ indexPath: IndexPath) {
    interactor.cancelPrepareItemFor(indexPath.item)
  }
  
  func presentCollectionUpdates(_ updates: CollectionViewModelUpdate) {
    viewController.updateCollection(updates)
  }
  
  func presentReload() {
    viewController.reloadData()
  }
}

// MARK: - ReferUser Viper Components
fileprivate extension ReferUserPresenter {
  var viewController: ReferUserViewControllerApi {
    return _viewController as! ReferUserViewControllerApi
  }
  var interactor: ReferUserInteractorApi {
    return _interactor as! ReferUserInteractorApi
  }
  var router: ReferUserRouterApi {
    return _router as! ReferUserRouterApi
  }
}
