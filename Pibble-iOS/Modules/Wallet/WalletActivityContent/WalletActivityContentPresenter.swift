//
//  WalletActivityContentPresenter.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 25.08.2018.
//Copyright © 2018 com.kazai. All rights reserved.
//

import UIKit

// MARK: - WalletActivityContentPresenter Class
final class WalletActivityContentPresenter: Presenter {
  fileprivate var invoiceAction: Wallet.WalletActivityInvoiceAction?
  fileprivate let presentationType: WalletActivityContent.PresentationType
  
  override func viewWillAppear() {
    super.viewWillAppear()
    interactor.initialRefresh()
    updatePlaceholderPresentationAnimated(false)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    interactor.initialFetchData()
  }
  
  init(presentationType: WalletActivityContent.PresentationType) {
    self.presentationType = presentationType
  }
}

// MARK: - WalletActivityContentPresenter API
extension WalletActivityContentPresenter: WalletActivityContentPresenterApi {
  func handleHideAction() {
    router.dismiss()
  }
  
  func handleWalletActivityActionAt(_ indexPath: IndexPath, action: WalletActivityContent.WalletActivityAction) {
    guard let item = interactor.itemAt(indexPath) else {
      return
    }
    
    switch item {
    case .internalTransaction(_):
      break
    case .externalTransaction(let entity):
      switch action {
      case .copyTransactionId:
        UIPasteboard.general.string = entity.transactionId
      case .showUserProfile:
        break
      }
    case .invoice(_):
      break
    case .rewardTransaction(_):
      break
    case .exchangeTransaction(_):
      break
    case .fundingTransaction(_):
      break
    case .promotionTransaction(_):
      break
    case .externalExchangeTransaction(_):
      break
    case .commerceTransaction(_):
      break
    case .digitalGoodTransaction(_):
      break
    case .airdropTransaction(_):
      break
    case .goodTransaction(_):
      break
    case .charityFundingDonateTransaction(let transaction):
      switch action {
      case .copyTransactionId:
        break
      case .showUserProfile:
        if let user = transaction.activityFromUser {
          router.routeToUserProfileFor(user)
        }
      }
    case .crowdFundingDonateTransaction(let transaction):
      switch action {
      case .copyTransactionId:
        break
      case .showUserProfile:
        if let user = transaction.activityFromUser {
          router.routeToUserProfileFor(user)
        }
      }
    case .crowdFundingWithRewardsDonateTransaction(let transaction):
      switch action {
      case .copyTransactionId:
        break
      case .showUserProfile:
        if let user = transaction.activityFromUser {
          router.routeToUserProfileFor(user)
        }
      }
    case .charityFundingRefundTransaction(_):
      break
    case .crowdFundingRefundTransaction(_):
      break
    case .crowdFundingWithRewardsRefundTransaction(_):
      break
    case .charityFundingResultTransaction(_):
      break
    case .crowdFundingResultTransaction(_):
      break
    case .crowdFundingWithRewardsResultTransaction(_):
      break
    case .postHelpPaymentTransaction, .postHelpRewardTransaction:
      break
    }
    
    
    
    
    
  }
  
  func handleInvoiceActionAt(_ indexPath: IndexPath, action: Wallet.WalletActivityInvoiceAction) {
    viewController.setInteractionEnabled(false)
    interactor.selectItemAt(indexPath)
    
    guard interactor.hasPinCode else {
      invoiceAction = action
      router.routeToPinCodeUnlock(delegate: self)
      return
    }
    
    performInvoiceAction(action)
  }
  
  func presentReload() {
    updatePlaceholderPresentationAnimated(true)
    viewController.reloadData()
  }
  
  func handleWillDisplayItem(_ indexPath: IndexPath) {
    interactor.prepareItemFor(indexPath.item)
  }
  
  func handleDidEndDisplayItem(_ indexPath: IndexPath) {
    interactor.cancelPrepareItemFor(indexPath.item)
  }
  
  func presentCollectionUpdates(_ updates: CollectionViewModelUpdate) {
    if case CollectionViewModelUpdate.endUpdates = updates {
      updatePlaceholderPresentationAnimated(true)
    }
    
    viewController.updateCollection(updates)
  }
  
  func numberOfSections() -> Int {
    return interactor.numberOfSections()
  }
  
  func numberOfItemsInSection(_ section: Int) -> Int {
    return interactor.numberOfItemsInSection(section)
  }
  
  func itemViewModelAt(_ indexPath: IndexPath) -> WalletActivityContent.ActivityViewModelType {
    guard let item = interactor.itemAt(indexPath) else {
      return .loadingPlaceholder
    }
    
    guard let currentUser = interactor.currentUserAccount else {
      return .loadingPlaceholder
    }
    
    switch presentationType {
    case .walletActivities:
      return WalletActivityContent.ActivityViewModelType.viewModelFor(baseWalletActivity: item, currentUser: currentUser)
    case .donationTransactions:
      return WalletActivityContent.ActivityViewModelType.donationsPresentationViewModelFor(baseWalletActivity: item, currentUser: currentUser)
    }
  }
  
  func presentInvoiceActionPerfomedSuccefully(_ success: Bool) {
    viewController.setInteractionEnabled(true)
  }
}

// MARK: - WalletActivityContent Viper Components
fileprivate extension WalletActivityContentPresenter {
  var viewController: WalletActivityContentViewControllerApi {
    return _viewController as! WalletActivityContentViewControllerApi
  }
  
  var interactor: WalletActivityContentInteractorApi {
    return _interactor as! WalletActivityContentInteractorApi
  }
  var router: WalletActivityContentRouterApi {
    return _router as! WalletActivityContentRouterApi
  }
}

extension WalletActivityContentPresenter: WalletPinCodeUnlockDelegateProtocol {
  func walletDidUnlockWith(_ pinCode: String) {
    guard let action = invoiceAction else {
      viewController.setInteractionEnabled(true)
      return
    }
    
    performInvoiceAction(action)
  }
  
  func walletDidFailToUnlock() {
    invoiceAction = nil
    viewController.setInteractionEnabled(true)
  }
}

//MARK:- Helpers

extension WalletActivityContentPresenter {
  fileprivate func dataPlaceholderViewModel() -> DataPlaceholderViewModelProtocol {
    switch interactor.contentType {
    case .walletActivities(let currencyType):
      let viewModel = WalletActivityContent.DataPlaceholderViewModel(currencyType: currencyType)
      return viewModel
    case .donationsForPost:
      let viewModel = WalletActivityContent.DataPlaceholderViewModel(currencyType: nil)
      return viewModel
    }
  }
  
  fileprivate func updatePlaceholderPresentationAnimated(_ animated: Bool) {
    guard interactor.numberOfSections() != 0 else {
      viewController.setDataPlaceholderViewModel(dataPlaceholderViewModel(), animated: animated)
      return
    }
    
    guard interactor.numberOfItemsInSection(0) > 0 else {
      viewController.setDataPlaceholderViewModel(dataPlaceholderViewModel(), animated: animated)
      return
    }
    
    viewController.setDataPlaceholderViewModel(nil, animated: animated)
  }
  
//  fileprivate func performInvoiceAction(_ invoiceAction: (IndexPath, Wallet.WalletActivityInvoiceAction)) {
//    switch invoiceAction.1 {
//    case .cancel:
//      interactor.cancelInvoiceAt(invoiceAction.0)
//    case .confirm:
//      interactor.confirmInvoiceAt(invoiceAction.0)
//    }
//  }
  
  fileprivate func performInvoiceAction(_ invoiceAction: Wallet.WalletActivityInvoiceAction) {
    switch invoiceAction {
    case .cancel:
      interactor.cancelSelectedInvoiceItem()
    case .confirm:
      interactor.confirmSelectedInvoiceItem()
    }
  }
}
