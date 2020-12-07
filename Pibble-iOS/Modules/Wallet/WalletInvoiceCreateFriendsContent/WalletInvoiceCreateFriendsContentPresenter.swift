//
//  WalletInvoiceCreateFriendsContentPresenter.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 01.09.2018.
//Copyright © 2018 com.kazai. All rights reserved.
//

import Foundation

// MARK: - WalletInvoiceCreateFriendsContentPresenter Class
final class WalletInvoiceCreateFriendsContentPresenter: Presenter {
  fileprivate weak var userPickDelegate: UserPickDelegateProtocol?
  fileprivate var selectedIndexPath: IndexPath?
  init(userPickDelegate: UserPickDelegateProtocol) {
    self.userPickDelegate = userPickDelegate
  }
  
  override func viewWillAppear() {
    super.viewWillAppear()
    viewController.reloadData()
    interactor.initialRefresh()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    interactor.initialFetchData()
  }
}

// MARK: - WalletInvoiceCreateFriendsContentPresenter API
extension WalletInvoiceCreateFriendsContentPresenter: WalletInvoiceCreateFriendsContentPresenterApi {
  func handleSelectionAt(_ indexPath: IndexPath) {
    let user = interactor.itemAt(indexPath)
    userPickDelegate?.didSelectUser(user)
    viewController.updateCollection(.beginUpdates)
    var indeces = [indexPath]
    if let selected = selectedIndexPath {
      indeces.append(selected)
    }
    viewController.updateCollection(.update(idx: indeces))
    viewController.updateCollection(.endUpdates)
  }
  
  func handleWillDisplayItem(_ indexPath: IndexPath) {
    interactor.prepareItemFor(indexPath.item)
  }
  
  func handleDidEndDisplayItem(_ indexPath: IndexPath) {
    interactor.cancelPrepareItemFor(indexPath.item)
  }
  
  func numberOfSections() -> Int {
    return interactor.numberOfSections()
  }
  
  func numberOfItemsInSection(_ section: Int) -> Int {
    return interactor.numberOfItemsInSection(section)
  }
  
  func itemViewModelAt(_ indexPath: IndexPath) -> WalletInvoiceCreateFriendViewModelProtocol {
    let item = interactor.itemAt(indexPath)
    let isSelected = userPickDelegate?.selectedUser()?.identifier == item.identifier
    if isSelected {
      selectedIndexPath = indexPath
    }
    
    return WalletInvoiceCreateFriendsContent.WalletInvoiceCreateFriendViewModel(user: item, isSelected: isSelected)
  }
  
  func presentReload() {
    viewController.reloadData()
  }
  
  func presentCollectionUpdates(_ updates: CollectionViewModelUpdate) {
    viewController.updateCollection(updates)
  }
  
}

// MARK: - WalletInvoiceCreateFriendsContent Viper Components
fileprivate extension WalletInvoiceCreateFriendsContentPresenter {
    var viewController: WalletInvoiceCreateFriendsContentViewControllerApi {
        return _viewController as! WalletInvoiceCreateFriendsContentViewControllerApi
    }
    var interactor: WalletInvoiceCreateFriendsContentInteractorApi {
        return _interactor as! WalletInvoiceCreateFriendsContentInteractorApi
    }
    var router: WalletInvoiceCreateFriendsContentRouterApi {
        return _router as! WalletInvoiceCreateFriendsContentRouterApi
    }
}
