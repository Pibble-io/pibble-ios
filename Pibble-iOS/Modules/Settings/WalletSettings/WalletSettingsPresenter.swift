//
//  WalletSettingsPresenter.swift
//  Pibble-iOS
//
//  Created by Sergey Kazakov on 15/05/2019.
//Copyright © 2019 com.kazai. All rights reserved.
//

import Foundation

// MARK: - WalletSettingsPresenter Class
final class WalletSettingsPresenter: Presenter {
  
  fileprivate var sections: [(section: WalletSettingsSections, items: [WalletSettings.SettingsItems])]  {
    return [(section: .nativeCurrency, items: [.nativeCurrency(pickedBalance)])
    ]
  }
  
  fileprivate var pickedBalance: BalanceCurrency?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    interactor.initialFetchData()
  }
}

//MARK:- Helpers
extension WalletSettingsPresenter {
  fileprivate func itemAt(indexPath: IndexPath) -> WalletSettings.SettingsItems {
    return sections[indexPath.section].items[indexPath.item]
  }
  
  fileprivate func getWalletSettingsValueFor(_ item: WalletSettings.SettingsItems) -> String? {
    switch item {
    case .nativeCurrency(let currency):
      return currency?.symbol
    }
  }
  
  fileprivate func setAccountCurrency(_ balanceCurrency: BalanceCurrency) {
    pickedBalance = balanceCurrency
    viewController.reloadData()
  }
}

extension WalletSettingsPresenter: AccountCurrencyPickerDelegateProtocol {
  func didSelectedCurrency(_ balanceCurrency: BalanceCurrency) {
    setAccountCurrency(balanceCurrency)
    interactor.performSetAccountCurrency(balanceCurrency)
  }
  
  func selectedCurrency() -> BalanceCurrency? {
    return pickedBalance
  }
}


// MARK: - WalletSettingsPresenter API
extension WalletSettingsPresenter: WalletSettingsPresenterApi {
  
  func presentUserAccount(_ userProfile: AccountProfileProtocol) {
    setAccountCurrency(userProfile.accountNativeCurrency)
  }
   
  
  func numberOfSections() -> Int {
    return sections.count
  }
  
  func numberOfItemsInSection(_ section: Int) -> Int {
    return sections[section].items.count
  }
  
  func itemViewModelAt(_ indexPath: IndexPath) -> WalletSettingsItemViewModelProtocol {
    let settingsItem = itemAt(indexPath: indexPath)
    let shouldHaveUpperSeparator = false
    let value = getWalletSettingsValueFor(settingsItem)
    return WalletSettings.WalletSettingsItemViewModel(settingsItem: settingsItem,
                                                      value: value,
                                                      shouldHaveUpperSeparator: shouldHaveUpperSeparator)
  }
  
  func handleSelectionAt(_ indexPath: IndexPath) {
    let item = itemAt(indexPath: indexPath)
    switch item {
    case .nativeCurrency(_):
      router.routeToNativeCurrencyPicker(self)
    }
  }
  
  func handleHideAction() {
    router.dismiss()
  }
}

// MARK: - WalletSettings Viper Components
fileprivate extension WalletSettingsPresenter {
  var viewController: WalletSettingsViewControllerApi {
    return _viewController as! WalletSettingsViewControllerApi
  }
  var interactor: WalletSettingsInteractorApi {
    return _interactor as! WalletSettingsInteractorApi
  }
  var router: WalletSettingsRouterApi {
    return _router as! WalletSettingsRouterApi
  }
}

fileprivate enum WalletSettingsSections {
  case nativeCurrency
}

