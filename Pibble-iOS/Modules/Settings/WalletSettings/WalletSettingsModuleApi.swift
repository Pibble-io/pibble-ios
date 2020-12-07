//
//  WalletSettingsModuleApi.swift
//  Pibble-iOS
//
//  Created by Sergey Kazakov on 15/05/2019.
//Copyright © 2019 com.kazai. All rights reserved.
//

import UIKit

//MARK: - WalletSettingsRouter API
protocol WalletSettingsRouterApi: RouterProtocol {
  func routeToNativeCurrencyPicker(_ delegate: AccountCurrencyPickerDelegateProtocol)
}

//MARK: - WalletSettingsView API
protocol WalletSettingsViewControllerApi: ViewControllerProtocol {
  func reloadData()
}

//MARK: - WalletSettingsPresenter API
protocol WalletSettingsPresenterApi: PresenterProtocol {
  func handleHideAction()
  
  func numberOfSections() -> Int
  func numberOfItemsInSection(_ section: Int) -> Int
  func itemViewModelAt(_ indexPath: IndexPath) -> WalletSettingsItemViewModelProtocol
  func handleSelectionAt(_ indexPath: IndexPath)
  
  func presentUserAccount(_ userProfile: AccountProfileProtocol)
}

//MARK: - WalletSettingsInteractor API
protocol WalletSettingsInteractorApi: InteractorProtocol {
  func initialFetchData()
  func initialRefreshData()
  func performSetAccountCurrency(_ balanceCurrency: BalanceCurrency) 
}


protocol WalletSettingsItemViewModelProtocol {
  var title: String { get }
  var pickedValue: String { get }
  var isUpperSeparatorVisible: Bool { get }
  var isRightArrowVisible: Bool { get }
  var titleColor: UIColor { get }
}
