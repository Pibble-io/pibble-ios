//
//  WalletInvoiceCreateFriendsContentModuleApi.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 01.09.2018.
//Copyright © 2018 com.kazai. All rights reserved.
//

import UIKit

//MARK: - WalletInvoiceCreateFriendsContentRouter API
protocol WalletInvoiceCreateFriendsContentRouterApi: RouterProtocol {
}

//MARK: - WalletInvoiceCreateFriendsContentView API
protocol WalletInvoiceCreateFriendsContentViewControllerApi: ViewControllerProtocol {
  func updateCollection(_ updates: CollectionViewModelUpdate)
  func reloadData()
}

//MARK: - WalletInvoiceCreateFriendsContentPresenter API
protocol WalletInvoiceCreateFriendsContentPresenterApi: PresenterProtocol {
  func handleWillDisplayItem(_ indexPath: IndexPath)
  func handleDidEndDisplayItem(_ indexPath: IndexPath)
  
  func handleSelectionAt(_ indexPath: IndexPath)
  func numberOfSections() -> Int
  func numberOfItemsInSection(_ section: Int) -> Int
  func itemViewModelAt(_ indexPath: IndexPath) -> WalletInvoiceCreateFriendViewModelProtocol
  
  func presentReload()
  func presentCollectionUpdates(_ updates: CollectionViewModelUpdate)
}

//MARK: - WalletInvoiceCreateFriendsContentInteractor API
protocol WalletInvoiceCreateFriendsContentInteractorApi: InteractorProtocol {
  func initialRefresh()
  func initialFetchData()
  func numberOfSections() -> Int
  func numberOfItemsInSection(_ section: Int) -> Int
  func itemAt(_ indexPath: IndexPath) -> UserProtocol
  
  func prepareItemFor(_ indexPath: Int)
  func cancelPrepareItemFor(_ indexPath: Int)
}

protocol WalletInvoiceCreateFriendViewModelProtocol {
  var userpicPlaceholder: UIImage? { get }
  var userpic: String { get }
  var username: String { get }
  var isSelected: Bool { get }
}

protocol UserPickDelegateProtocol: class {
  func didSelectUser(_ user: UserProtocol)
  func selectedUser() -> UserProtocol?
}
