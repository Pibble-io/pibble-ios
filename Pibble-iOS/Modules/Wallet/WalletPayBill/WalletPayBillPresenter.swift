//
//  WalletPayBillPresenter.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 28.08.2018.
//Copyright © 2018 com.kazai. All rights reserved.
//

import Foundation

// MARK: - WalletPayBillPresenter Class
final class WalletPayBillPresenter: WalletPinCodeSecuredPresenter {
  fileprivate var invoiceAction: (Wallet.WalletActivityInvoiceAction)?
  
  override func viewWillAppear() {
    super.viewWillAppear()
    interactor.initialRefresh()
    viewController.setPlaceholderHidden(interactor.hasDataToPresent, animated: false)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    interactor.initialFetchData()
    
  }
}

extension WalletPayBillPresenter {
  fileprivate func performInvoiceAction(_ invoiceAction: Wallet.WalletActivityInvoiceAction) {
    switch invoiceAction {
    case .cancel:
      interactor.cancelSelectedItem()
    case .confirm:
      interactor.confirmSelectedItem()
    }
  }
}


// MARK: - WalletPayBillPresenter API
extension WalletPayBillPresenter: WalletPayBillPresenterApi {
  func presentInvoiceActionPerfomedSuccefully(_ success: Bool) {
    viewController.setInteractionEnabled(true)
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
  
  func itemViewModelAt(_ indexPath: IndexPath) -> WalletPayBill.ItemViewModelType {
    guard let item = interactor.itemAt(indexPath) else {
      return .loadingPlaceholder
    }
    
    guard let user = interactor.currentUser else{
      return .loadingPlaceholder
    }
    
    return .invoice(Wallet.WalletActivityInvoiceViewModel(walletActivity: item, currentUser: user))
  }
  
  func presentUserProfile(_ profile: UserProtocol?) {
    guard let userProfile = profile else {
      viewController.setProfile(nil)
      return
    }
    let viewModel = Wallet.WalletProfileHeaderViewModel(userProfile: userProfile)
    viewController.setProfile(viewModel)
  }
  
  func presentReload() {
    viewController.reloadData()
  }
  
  func presentCollectionUpdates(_ updates: CollectionViewModelUpdate) {
    viewController.updateCollection(updates)
    guard case CollectionViewModelUpdate.endUpdates = updates else {
      return
    }
    viewController.setPlaceholderHidden(interactor.hasDataToPresent, animated: true)
  }
  
  func handleWillDisplayItem(_ indexPath: IndexPath) {
    interactor.prepareItemFor(indexPath)
  }
  
  func handleDidEndDisplayItem(_ indexPath: IndexPath) {
     interactor.cancelPrepareItemFor(indexPath)
  }
  
  func handleHideAction() {
    router.dismiss()
  }
  
  func numberOfSections() -> Int {
    return interactor.numberOfSections()
  }
  
  func numberOfItemsInSection(_ section: Int) -> Int {
    return interactor.numberOfItemsInSection(section)
  }
}

extension WalletPayBillPresenter: WalletPinCodeUnlockDelegateProtocol {
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

// MARK: - WalletPayBill Viper Components
fileprivate extension WalletPayBillPresenter {
    var viewController: WalletPayBillViewControllerApi {
        return _viewController as! WalletPayBillViewControllerApi
    }
    var interactor: WalletPayBillInteractorApi {
        return _interactor as! WalletPayBillInteractorApi
    }
    var router: WalletPayBillRouterApi {
        return _router as! WalletPayBillRouterApi
    }
}
