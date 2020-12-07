//
//  WalletPayBillModuleApi.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 28.08.2018.
//Copyright © 2018 com.kazai. All rights reserved.
//
import Foundation

//MARK: - WalletPayBillRouter API
protocol WalletPayBillRouterApi: WalletPinCodeSecuredRouterProtocol {
  func routeToPinCodeUnlock(delegate: WalletPinCodeUnlockDelegateProtocol)
  
}

//MARK: - WalletPayBillView API
protocol WalletPayBillViewControllerApi: ViewControllerProtocol {
  func updateCollection(_ updates: CollectionViewModelUpdate)
  func reloadData()
  func setProfile(_ vm: WalletProfileHeaderViewModelProtocol?)
  func setPlaceholderHidden(_ hidden: Bool, animated: Bool)
  
  func setInteractionEnabled(_ enabled: Bool)
}

//MARK: - WalletPayBillPresenter API
protocol WalletPayBillPresenterApi: PresenterProtocol {
  func handleWillDisplayItem(_ indexPath: IndexPath)
  func handleDidEndDisplayItem(_ indexPath: IndexPath)
  func handleHideAction()
  func handleInvoiceActionAt(_ indexPath: IndexPath, action: Wallet.WalletActivityInvoiceAction)
  
  func numberOfSections() -> Int
  func numberOfItemsInSection(_ section: Int) -> Int
  func itemViewModelAt(_ indexPath: IndexPath) -> WalletPayBill.ItemViewModelType
  
  func presentReload()
  func presentUserProfile(_ profile: UserProtocol?)
  func presentCollectionUpdates(_ updates: CollectionViewModelUpdate)
  
  func presentInvoiceActionPerfomedSuccefully(_ success: Bool)
  
}

//MARK: - WalletPayBillInteractor API
protocol WalletPayBillInteractorApi: InteractorProtocol {
  var currentUser: UserProtocol? { get }
  var hasDataToPresent: Bool { get }
  func numberOfSections() -> Int
  func numberOfItemsInSection(_ section: Int) -> Int
  func itemAt(_ indexPath: IndexPath) -> InvoiceProtocol?
  
  func prepareItemFor(_ indexPath: IndexPath)
  func cancelPrepareItemFor(_ indexPath: IndexPath)
  
  func initialFetchData()
  func initialRefresh()
  
  var hasPinCode: Bool { get }
  
  func selectItemAt(_ indexPath: IndexPath)
  func cancelSelectedItem()
  func confirmSelectedItem()
}
