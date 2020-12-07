//
//  AccountCurrencyPickerPresenter.swift
//  Pibble-iOS
//
//  Created by Sergey Kazakov on 15/05/2019.
//Copyright © 2019 com.kazai. All rights reserved.
//

import Foundation

// MARK: - AccountCurrencyPickerPresenter Class
final class AccountCurrencyPickerPresenter: Presenter {
  fileprivate weak var delegate: AccountCurrencyPickerDelegateProtocol?
  
  fileprivate var sections: [(section: AccountCurrencyPickerSections, items: [BalanceCurrency])] =  [
    (section: .nativeCurrency, items: BalanceCurrency.nativeCurrencies)
  ]
  
  fileprivate var selectedItem: BalanceCurrency?
  
  override func viewWillAppear() {
    super.viewWillAppear()
    selectedItem = delegate?.selectedCurrency()
    viewController.reloadData()
  }
  
  init(delegate: AccountCurrencyPickerDelegateProtocol) {
    self.delegate = delegate
  }
}

//MARK:- Helpers
extension AccountCurrencyPickerPresenter {
  fileprivate func itemAt(indexPath: IndexPath) -> BalanceCurrency {
    return sections[indexPath.section].items[indexPath.item]
  }
}


// MARK: - AccountCurrencyPickerPresenter API
extension AccountCurrencyPickerPresenter: AccountCurrencyPickerPresenterApi {
  func presentUserAccount(_ userProfile: AccountProfileProtocol) {
    selectedItem = userProfile.accountNativeCurrency
    viewController.reloadData()
  }
  
  func presentMyGoodsForUser(_ user: UserProtocol) {
    router.routeToMyGoodsListForCurrentUser(user)
  }
  
  func presentPurchasedGoodsForUser(_ user: UserProtocol) {
    router.routeToPurchasedGoodsListForCurrentUser(user)
  }
  
  func numberOfSections() -> Int {
    return sections.count
  }
  
  func numberOfItemsInSection(_ section: Int) -> Int {
    return sections[section].items.count
  }
  
  func itemViewModelAt(_ indexPath: IndexPath) -> AccountCurrencyPickerItemViewModelProtocol {
    let item = itemAt(indexPath: indexPath)
    let shouldHaveUpperSeparator = false
    let isSelected = item == selectedItem
    
    return AccountCurrencyPicker.AccountCurrencyPickerItemViewModel(currency: item,
                                                      isSelected: isSelected,
                                                      shouldHaveUpperSeparator: shouldHaveUpperSeparator)
  }
  
  func handleSelectionAt(_ indexPath: IndexPath) {
    let item = itemAt(indexPath: indexPath)
    selectedItem = item
    viewController.reloadData()
    delegate?.didSelectedCurrency(item)
    router.dismiss()
  }
  
  func handleHideAction() {
    router.dismiss()
  }
}

// MARK: - AccountCurrencyPicker Viper Components
fileprivate extension AccountCurrencyPickerPresenter {
  var viewController: AccountCurrencyPickerViewControllerApi {
    return _viewController as! AccountCurrencyPickerViewControllerApi
  }
  var interactor: AccountCurrencyPickerInteractorApi {
    return _interactor as! AccountCurrencyPickerInteractorApi
  }
  var router: AccountCurrencyPickerRouterApi {
    return _router as! AccountCurrencyPickerRouterApi
  }
}

fileprivate enum AccountCurrencyPickerSections {
  case nativeCurrency
}

