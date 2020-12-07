//
//  WalletTransactionCurrencyPickModuleApi.swift
//  Pibble-iOS
//
//  Created by Sergey Kazakov on 08/07/2019.
//Copyright © 2019 com.kazai. All rights reserved.
//

import UIKit

//MARK: - WalletTransactionCurrencyPickRouter API
protocol WalletTransactionCurrencyPickRouterApi: RouterProtocol {
  func routeToPinCodeUnlock(delegate: WalletPinCodeUnlockDelegateProtocol)
  func routeToHome()
}

//MARK: - WalletTransactionCurrencyPickView API
protocol WalletTransactionCurrencyPickViewControllerApi: ViewControllerProtocol {
  func setViewItemsModels(_ vms: [WalletTransactionCurrencyPickItemViewModelProtocol], animated: Bool)
  func setSendButtonEnabled(_ enabled: Bool)
  
  func setWarningTitle(_ attributedText: NSAttributedString)
  func setCurrencyTitle(_ text: String)
}

//MARK: - WalletTransactionCurrencyPickPresenter API
protocol WalletTransactionCurrencyPickPresenterApi: PresenterProtocol {
  func handleCurrencySelectionAt(_ index: Int)
  func handleSendAction()
  func handleHideAction()
  
  func presentCurrencies(_ currencies: [BalanceCurrency], selectedCurrency: BalanceCurrency?)
  func presentTransactionSentSuccefully(_ success: Bool)
}

//MARK: - WalletTransactionCurrencyPickInteractor API
protocol WalletTransactionCurrencyPickInteractorApi: InteractorProtocol {
  var initialCurrency: BalanceCurrency { get }
  var hasPinCode: Bool { get }
  
  func initialFetchData()
  func selectCurrencyAt(_ index: Int)
  func createTransaction()
}

protocol WalletTransactionCurrencyPickItemViewModelProtocol {
  var isSelected: Bool { get }
  var title: String { get }
}
