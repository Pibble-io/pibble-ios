//
//  WalletPreviewModuleApi.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 15.10.2018.
//Copyright © 2018 com.kazai. All rights reserved.
//

import UIKit

//MARK: - WalletPreviewRouter API
protocol WalletPreviewRouterApi: RouterProtocol {
  func routeToWallet() 
}

//MARK: - WalletPreviewView API
protocol WalletPreviewViewControllerApi: ViewControllerProtocol {
  func reloadData()
}

//MARK: - WalletPreviewPresenter API
protocol WalletPreviewPresenterApi: PresenterProtocol {
  func handleWalletAction()
  
  func numberOfSections() -> Int
  func numberOfItemsInSection(_ section: Int) -> Int
  func itemViewModelAt(_ indexPath: IndexPath) -> WalletPreviewItemViewModelProtocol
  
  func presentReload()
}

//MARK: - WalletPreviewInteractor API
protocol WalletPreviewInteractorApi: InteractorProtocol {
  func initialFetchData()
 
  var currentUserAccount: (account: AccountProfileProtocol?, limits: AccountUpvoteLimitsProtocol?)  { get }
}

protocol WalletPreviewItemViewModelProtocol {
  var itemImage: UIImage { get }
  var itemAmount: String { get }
  var itemTitle: String { get }
}
