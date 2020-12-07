//
//  WalletInvoiceCreatePresenter.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 31.08.2018.
//Copyright © 2018 com.kazai. All rights reserved.
//

import Foundation

// MARK: - WalletInvoiceCreatePresenter Class
final class WalletInvoiceCreatePresenter: WalletPinCodeSecuredPresenter {
  override func viewWillAppear() {
    super.viewWillAppear()
    interactor.initialFetchData()
  }
}

// MARK: - WalletInvoiceCreatePresenter API
extension WalletInvoiceCreatePresenter: WalletInvoiceCreatePresenterApi {
  func presentInvoiceSentSuccefully(_ success: Bool) {
    guard success else {
      viewController.setPostingButtonPresentation(true)
      viewController.setPostingButtonInteraction(true)
      return
    }
    
    router.routeToHome()
  }
  
  
  func present(mainBalance: Balance, secondaryBalance: Balance) {
    let needsDecimalInput = mainBalance.currency.supportsDecimal && secondaryBalance.currency.supportsDecimal
    
    let viewModel =
      Wallet.WalletRequestAmountInputViewModel(nextButtonTitle: UIConstants.nextButtonTitle,
                                               title: UIConstants.inputTitle,
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
    viewController.setPostingButtonInteraction(false)
    viewController.setPostingButtonPresentation(false)
    interactor.createInvoice()
  }
  
  func presentCreateInvoiceEnabled(_ enabled: Bool) {
    viewController.setPostingButtonPresentation(enabled)
  }
  
  func handleDescriptionChanged(_ value: String) {
    interactor.updateDescriptionWith(value)
  }
  
  func handleSwitchTo(_ segment: WalletInvoiceCreate.SelectedSegment) {
    router.routeTo(segment, insideView: viewController.submoduleContainerView, delegate: self)
  }
  
  func handleHideAction() {
    router.dismiss()
  }
}

// MARK: - WalletInvoiceCreate Viper Components
fileprivate extension WalletInvoiceCreatePresenter {
    var viewController: WalletInvoiceCreateViewControllerApi {
        return _viewController as! WalletInvoiceCreateViewControllerApi
    }
    var interactor: WalletInvoiceCreateInteractorApi {
        return _interactor as! WalletInvoiceCreateInteractorApi
    }
    var router: WalletInvoiceCreateRouterApi {
        return _router as! WalletInvoiceCreateRouterApi
    }
}

extension WalletInvoiceCreatePresenter: UserPickDelegateProtocol {
  func selectedUser() -> UserProtocol? {
    return interactor.invoiceRecipientUser
  }
  
  func didSelectUser(_ user: UserProtocol) {
    interactor.invoiceRecipientUser = user
  }  
}

fileprivate enum UIConstants {
  static let inputTitle = "Request Amount"
  static let nextButtonTitle = "Next"
}
