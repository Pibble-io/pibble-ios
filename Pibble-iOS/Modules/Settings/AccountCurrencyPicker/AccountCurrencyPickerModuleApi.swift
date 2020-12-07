//
//  AccountCurrencyPickerModuleApi.swift
//  Pibble-iOS
//
//  Created by Sergey Kazakov on 15/05/2019.
//Copyright © 2019 com.kazai. All rights reserved.
//

import UIKit

//MARK: - AccountCurrencyPickerRouter API
protocol AccountCurrencyPickerRouterApi: RouterProtocol {
  func routeToMyGoodsListForCurrentUser(_ user: UserProtocol)
  func routeToPurchasedGoodsListForCurrentUser(_ user: UserProtocol)
  
  func routeToNativeCurrencyPicker()
}

//MARK: - AccountCurrencyPickerView API
protocol AccountCurrencyPickerViewControllerApi: ViewControllerProtocol {
  func reloadData()
}

//MARK: - AccountCurrencyPickerPresenter API
protocol AccountCurrencyPickerPresenterApi: PresenterProtocol {
  func handleHideAction()
  
  func numberOfSections() -> Int
  func numberOfItemsInSection(_ section: Int) -> Int
  func itemViewModelAt(_ indexPath: IndexPath) -> AccountCurrencyPickerItemViewModelProtocol
  func handleSelectionAt(_ indexPath: IndexPath)
  
  func presentMyGoodsForUser(_ user: UserProtocol)
  func presentPurchasedGoodsForUser(_ user: UserProtocol)
}

//MARK: - AccountCurrencyPickerInteractor API
protocol AccountCurrencyPickerInteractorApi: InteractorProtocol {
  
}


protocol AccountCurrencyPickerItemViewModelProtocol {
  var title: String { get }
  var subtitle: String { get }
  var pickedValue: String { get }
  
  var isUpperSeparatorVisible: Bool { get }
  var isRightArrowVisible: Bool { get }
  var titleColor: UIColor { get }
  var subtitleColor: UIColor { get }
}

protocol AccountCurrencyPickerDelegateProtocol: class {
  func didSelectedCurrency(_ balanceCurrency: BalanceCurrency)
  func selectedCurrency() -> BalanceCurrency?
}
