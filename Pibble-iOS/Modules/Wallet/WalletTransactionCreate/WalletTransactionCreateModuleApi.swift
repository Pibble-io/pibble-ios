//
//  WalletTransactionCreateModuleApi.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 10.09.2018.
//Copyright © 2018 com.kazai. All rights reserved.
//

import UIKit

//MARK: - WalletTransactionCreateRouter API
protocol WalletTransactionCreateRouterApi: WalletPinCodeSecuredRouterProtocol {
  func routeToHome()
  func routeToPinCodeUnlock(delegate: WalletPinCodeUnlockDelegateProtocol)
  
  func routeTo(_ segment: WalletTransactionCreate.SelectedUsersSegment, insideView: UIView, delegate: UserPickDelegateProtocol)
  func routeToQRCodeScanner(delegate: ScanQRCodeDelegateProtocol)
  func routeToCurrencyPicker(transaction: CreateExternalTransactionProtocol) 
}

//MARK: - WalletTransactionCreateView API
protocol WalletTransactionCreateViewControllerApi: ViewControllerProtocol {
  var submoduleContainerView: UIView  { get }
  func setPostingButtonPresentation(_ enabled: Bool, title: String)
  func setViewModel(_ vm: WalletRequestAmountInputViewModelProtocol)
  func setSelectedSegment(_ segment: WalletTransactionCreate.SelectedSegment)
  func setSegmentDeselected()
  
  func setWalletAddress(_ address: String)
}

//MARK: - WalletTransactionCreatePresenter API
protocol WalletTransactionCreatePresenterApi: PresenterProtocol {
  func handleAddressChange(_ value: String)
  
  func handleHideAction()
  func handleSendAction()
  func handleSwitchTo(_ segment: WalletTransactionCreate.SelectedUsersSegment)
  func handleSwitchTo(_ segment: WalletTransactionCreate.SelectedSegment)
  
  func present(mainBalance: Balance, secondaryBalance: Balance)
  func presentCreateInvoiceEnabled(_ enabled: Bool)
  func presentInvoiceSentSuccefully(_ success: Bool)
  
  func presentSelectedTransactionType(_ type: WalletTransactionCreate.TransactionType?)
}

//MARK: - WalletTransactionCreateInteractor API
protocol WalletTransactionCreateInteractorApi: InteractorProtocol {
  var mainCurrency: BalanceCurrency { get }
  func initialFetchData()
  
  
  func createTransaction()
  
  func setRecipientAddress(_ value: String)
  func resetPickedRecipient()
  
  var hasPinCode: Bool { get }
  var shouldPickCurrencyForTransaction: Bool { get }
  
  var externalTransaction: CreateExternalTransactionProtocol? { get }
  var invoiceRecipientUser: UserProtocol? { get set }
}
