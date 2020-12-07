//
//  LanguagePickerModuleApi.swift
//  Pibble-iOS
//
//  Created by Sergey Kazakov on 15/05/2019.
//Copyright © 2019 com.kazai. All rights reserved.
//

import UIKit

//MARK: - LanguagePickerRouter API
protocol LanguagePickerRouterApi: RouterProtocol {
  func routeToMyGoodsListForCurrentUser(_ user: UserProtocol)
  func routeToPurchasedGoodsListForCurrentUser(_ user: UserProtocol)
  
  func routeToNativeCurrencyPicker()
}

//MARK: - LanguagePickerView API
protocol LanguagePickerViewControllerApi: ViewControllerProtocol {
  func reloadData()
  func showLanguagePickConfirmationAlert()
}

//MARK: - LanguagePickerPresenter API
protocol LanguagePickerPresenterApi: PresenterProtocol {
  func handleHideAction()
  
  func numberOfSections() -> Int
  func numberOfItemsInSection(_ section: Int) -> Int
  func itemViewModelAt(_ indexPath: IndexPath) -> LanguagePickerItemViewModelProtocol
  func handleSelectionAt(_ indexPath: IndexPath)
  
  func presentMyGoodsForUser(_ user: UserProtocol)
  func presentPurchasedGoodsForUser(_ user: UserProtocol)
  
  func confirmLanguagePick()
}

//MARK: - LanguagePickerInteractor API
protocol LanguagePickerInteractorApi: InteractorProtocol {
  
}

protocol LanguagePickerItemViewModelProtocol {
  var title: String { get }
  var subtitle: String { get }
  var pickedValue: String { get }
  
  var isUpperSeparatorVisible: Bool { get }
  var isRightArrowVisible: Bool { get }
  var titleColor: UIColor { get }
  var subtitleColor: UIColor { get }
}

protocol LanguagePickerDelegateProtocol: class {
  func didSelectAppLanguage(_ balanceCurrency: AppLanguage)
  func selectedAppLanguage() -> AppLanguage?
}
