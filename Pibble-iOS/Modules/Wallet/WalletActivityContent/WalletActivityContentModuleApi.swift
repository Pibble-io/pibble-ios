//
//  WalletActivityContentModuleApi.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 25.08.2018.
//Copyright © 2018 com.kazai. All rights reserved.
//

import UIKit

//MARK: - WalletActivityContentRouter API
protocol WalletActivityContentRouterApi: RouterProtocol {
  func routeToPinCodeUnlock(delegate: WalletPinCodeUnlockDelegateProtocol)
  
  func routeToUserProfileFor(_ user: UserProtocol)
}

//MARK: - WalletActivityContentView API
protocol WalletActivityContentViewControllerApi: ViewControllerProtocol {
  func updateCollection(_ updates: CollectionViewModelUpdate)
  func reloadData()
  func setDataPlaceholderViewModel(_ vm: DataPlaceholderViewModelProtocol?, animated: Bool)
  
  func setInteractionEnabled(_ enabled: Bool)
}

//MARK: - WalletActivityContentPresenter API
protocol WalletActivityContentPresenterApi: PresenterProtocol {
  func handleHideAction()
  
  func handleWillDisplayItem(_ indexPath: IndexPath)
  func handleDidEndDisplayItem(_ indexPath: IndexPath)
  func handleInvoiceActionAt(_ indexPath: IndexPath, action: Wallet.WalletActivityInvoiceAction)
  func handleWalletActivityActionAt(_ indexPath: IndexPath, action: WalletActivityContent.WalletActivityAction)
  
  
  func numberOfSections() -> Int
  func numberOfItemsInSection(_ section: Int) -> Int
  func itemViewModelAt(_ indexPath: IndexPath) -> WalletActivityContent.ActivityViewModelType
  
  func presentReload()
  func presentCollectionUpdates(_ updates: CollectionViewModelUpdate)
  
  func presentInvoiceActionPerfomedSuccefully(_ success: Bool)
}

//MARK: - WalletActivityContentInteractor API
protocol WalletActivityContentInteractorApi: InteractorProtocol {
  var contentType: WalletActivityContent.ContentType { get }
  var currentUserAccount: UserProtocol? { get }
  
  func numberOfSections() -> Int
  func numberOfItemsInSection(_ section: Int) -> Int
  func itemAt(_ indexPath: IndexPath) -> WalletActivityEntity?
  
  func prepareItemFor(_ indexPath: Int)
  func cancelPrepareItemFor(_ indexPath: Int)
  
  func initialFetchData()
  func initialRefresh()
  
  var hasPinCode: Bool { get }
    
//  func confirmInvoiceAt(_ indexPath: IndexPath)
//  func cancelInvoiceAt(_ indexPath: IndexPath)
  
  func selectItemAt(_ indexPath: IndexPath)
  func cancelSelectedInvoiceItem()
  func confirmSelectedInvoiceItem()
}

protocol WalletActivityInternalTransactionViewModelProtocol {
  var transactionTitle: NSAttributedString { get }
  var userpicUrlString: String { get }
  var userpicPlaceholder: UIImage? { get }
  var isIncoming: Bool { get }
  var transactionDate: String { get }
  var transactionValue: String { get }
  var transactionNote: String { get }
  var currencyColor: UIColor { get }
}

protocol WalletActivityExtenalTransactionViewModelProtocol {
  var transactionId: String { get }
  var transactionTitle: String { get }
  var isIncoming: Bool { get }
  var transactionDate: String { get }
  var transactionValue: String { get }
  var transactionAddress: String { get }
  var currencyColor: UIColor { get }
}

protocol DataPlaceholderViewModelProtocol {
  var title: String { get }
  var subtitle: String { get }
}

protocol WalletActivityExchangeTransactionViewModelProtocol: WalletActivityInternalTransactionViewModelProtocol {
  
}
 

protocol WalletActivityDonatorTransactionViewModelProtocol {
  var avatarPlaceholder: UIImage? { get }
  var avatarURLString: String { get }
  var username: String { get }
  var userLevel: String { get }
  
  var priceTitle: String { get }
  var amount: String { get }
}
