//
//  WalletTransactionCreatePresenter.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 10.09.2018.
//Copyright © 2018 com.kazai. All rights reserved.
//

import Foundation

// MARK: - WalletTransactionCreatePresenter Class
final class WalletTransactionCreatePresenter: WalletPinCodeSecuredPresenter {
  override func viewWillAppear() {
    super.viewWillAppear()
    interactor.initialFetchData()
  }
  
  override func viewWillDisappear() {
    super.viewWillDisappear()
  }
}

// MARK: - WalletTransactionCreatePresenter API
extension WalletTransactionCreatePresenter: WalletTransactionCreatePresenterApi {
  func presentSelectedTransactionType(_ type: WalletTransactionCreate.TransactionType?) {
    guard let selectedType = type else {
      viewController.setSegmentDeselected()
      return
    }
    
    switch selectedType {
    case .internalTransaction:
      viewController.setSelectedSegment(.users)
    case .externalTransaction(let address):
      viewController.setWalletAddress(address)
    }
  }
  
  func handleAddressChange(_ value: String) {
    interactor.setRecipientAddress(value)
  }
  
  func handleSwitchTo(_ segment: WalletTransactionCreate.SelectedSegment) {
    switch segment {
    case .users:
      interactor.invoiceRecipientUser = nil
      viewController.setSelectedSegment(segment)
    case .address:
      viewController.setSelectedSegment(segment)
    case .pickQRCode:
      viewController.setSelectedSegment(segment)
      interactor.resetPickedRecipient()
      router.routeToQRCodeScanner(delegate: self)
    }
  }
  
  func presentInvoiceSentSuccefully(_ success: Bool) {
    guard success else {
      viewController.setPostingButtonPresentation(true, title: titleForSendingButton)
      return
    }
    
    router.routeToHome()
  }
  
  func present(mainBalance: Balance, secondaryBalance: Balance) {
    let needsDecimalInput = mainBalance.currency.supportsDecimal && secondaryBalance.currency.supportsDecimal
    let viewModel =
      Wallet.WalletRequestAmountInputViewModel(nextButtonTitle: WalletTransactionCreate.Strings.nextButtonTitle.localize(), title: WalletTransactionCreate.Strings.inputTitle.localize(),
                                               mainCurrencyAmount: String(mainBalance.value),
                                               mainCurrency: mainBalance.currency.symbolPresentation.uppercased(),
                                               secondaryCurrencyAmount: String(secondaryBalance.value),
                                               secondaryCurrency: secondaryBalance.currency.symbolPresentation.uppercased(), nextCurrencySwitchIsActive: false,
                                               swapCurrenciesIsActive: true, swapCurrenciesButtonStyle: .white,
                                               needsDecimalInput: needsDecimalInput,
                                               availableAmount: nil)
    viewController.setViewModel(viewModel)
  }
  
  func handleSendAction() {
    viewController.setPostingButtonPresentation(false, title: titleForSendingButton)
    
    guard !interactor.shouldPickCurrencyForTransaction else {
      guard let transaction = interactor.externalTransaction else {
        viewController.setPostingButtonPresentation(true, title: titleForSendingButton)
        return
      }
      
      router.routeToCurrencyPicker(transaction: transaction)
      return
    }
    
    guard interactor.hasPinCode else {
      router.routeToPinCodeUnlock(delegate: self)
      return
    }
    
    interactor.createTransaction()
  }
  
  func presentCreateInvoiceEnabled(_ enabled: Bool) {
    viewController.setPostingButtonPresentation(enabled, title: titleForSendingButton)
  }
   
  
  func handleSwitchTo(_ segment: WalletTransactionCreate.SelectedUsersSegment) {
    router.routeTo(segment, insideView: viewController.submoduleContainerView, delegate: self)
  }
  
  func handleHideAction() {
    router.dismiss()
  }
}

// MARK: - WalletInvoiceCreate Viper Components
fileprivate extension WalletTransactionCreatePresenter {
  var viewController: WalletTransactionCreateViewControllerApi {
    return _viewController as! WalletTransactionCreateViewControllerApi
  }
  var interactor: WalletTransactionCreateInteractorApi {
    return _interactor as! WalletTransactionCreateInteractorApi
  }
  var router: WalletTransactionCreateRouterApi {
    return _router as! WalletTransactionCreateRouterApi
  }
}

extension WalletTransactionCreatePresenter: UserPickDelegateProtocol {
  func selectedUser() -> UserProtocol? {
    return interactor.invoiceRecipientUser
  }
  
  func didSelectUser(_ user: UserProtocol) {
    interactor.invoiceRecipientUser = user 
  }
}

extension WalletTransactionCreatePresenter: WalletPinCodeUnlockDelegateProtocol {
  func walletDidUnlockWith(_ pinCode: String) {
    interactor.createTransaction()
  }
  
  func walletDidFailToUnlock() {
    viewController.setPostingButtonPresentation(true, title: titleForSendingButton)
  }
}

extension WalletTransactionCreatePresenter {
  var titleForSendingButton: String {
    guard interactor.shouldPickCurrencyForTransaction else {
      return WalletTransactionCreate.Strings.NavBarButtons.send.localize()
    }
    
    return WalletTransactionCreate.Strings.NavBarButtons.next.localize()
  }
}

extension WalletTransactionCreatePresenter: ScanQRCodeDelegateProtocol {
  func didCaptureQRCode(_ code: String) {
    interactor.setRecipientAddress(code)
  }
}

extension WalletTransactionCreate {
  enum Strings: String, LocalizedStringKeyProtocol {
    case inputTitle = "Request Amount"
    case nextButtonTitle = "Next"
    
    enum NavBarButtons: String, LocalizedStringKeyProtocol {
      case send = "Send"
      case next = "Next"
    }
  }
}
