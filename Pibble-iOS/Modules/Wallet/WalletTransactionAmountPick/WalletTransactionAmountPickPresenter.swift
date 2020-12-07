//
//  WalletRequestAmountPickPresenter.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 30.08.2018.
//Copyright © 2018 com.kazai. All rights reserved.
//

import Foundation

// MARK: - WalletTransactionAmountPickPresenter Class
final class WalletTransactionAmountPickPresenter: WalletPinCodeSecuredPresenter {
  fileprivate var transactionType: WalletTransactionAmountPick.TransactionType {
    return interactor.transactionType
  }
  
  fileprivate var currentInput: WalletTransactionAmountPick.AmountInput {
    return interactor.currentInput
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    interactor.initialFetchData()
    viewController.setNavBarTitle(navBarTitleFor(transactionType))
    presentUserProfile(interactor.userProfile, animated: false)
  }
}

// MARK: - WalletRequestAmountPickPresenter API
extension WalletTransactionAmountPickPresenter: WalletTransactionAmountPickPresenterApi {
  func presentUserProfile(_ profile: UserProtocol?) {
    presentUserProfile(profile, animated: true)
  }
  
  func handleSwitchToNextCurrency() {
//    currentInput = .main
    interactor.performSwitchToNextMainCurrency()
  }
  
  func presentExchangeSuccess() {
    router.dismiss()
  }
  
  func presentNextStageAvailable(_ available: Bool) {
    viewController.setNextStageButtonEnabled(available)
  }
  
  func present(mainBalance: Balance, secondaryBalance: Balance, availableBalance: Balance) {
    let mainBalanceForCurrentIntput: Balance
    let secondaryBalanceForCurrentIntput: Balance
    
    switch currentInput {
    case .main:
      mainBalanceForCurrentIntput = mainBalance
      secondaryBalanceForCurrentIntput = secondaryBalance
    case .secondary:
      mainBalanceForCurrentIntput = secondaryBalance
      secondaryBalanceForCurrentIntput = mainBalance
    }
    
    let numberFormatter = NumberFormatter()
    numberFormatter.numberStyle = .decimal
    let mainBalanceString = numberFormatter.string(from: NSNumber(value: mainBalanceForCurrentIntput.value)) ?? ""
    let secondaryBalanceString = numberFormatter.string(from: NSNumber(value: secondaryBalanceForCurrentIntput.value)) ?? ""
    
    let nextCurrencySwitchIsActive = interactor.mainCurrencies.count > 1
    let swapCurrenciesIsActive = interactor.isCurrencySwapAvailable
    let needsDecimalInput = mainBalance.currency.supportsDecimal && secondaryBalance.currency.supportsDecimal
    
    let availableAmount: String?
    
    var swapButtonStyle: SwapCurrenciesButtonStyle = .white
    switch interactor.transactionType {
    case .invoice:
      availableAmount = nil
    case .outcoming:
      availableAmount = "\(String(format: availableBalance.currency.stringFormat, availableBalance.value)) \(availableBalance.currency.symbol)"
    case .exchange:
      if mainBalance.currency == .redBrush || secondaryBalance.currency == .redBrush {
        swapButtonStyle = .prb
      }
      
      if mainBalance.currency == .greenBrush || secondaryBalance.currency == .greenBrush {
        swapButtonStyle = .pgb
      }
      
      availableAmount = nil
    }
    
    
    let viewModel =
      Wallet.WalletRequestAmountInputViewModel(nextButtonTitle: nextStageButtonTitleFor(transactionType),
                                               title: titleFor(transactionType),
                                               mainCurrencyAmount: mainBalanceString,
                                               mainCurrency: mainBalanceForCurrentIntput.currency.symbolPresentation.uppercased(),
                                               secondaryCurrencyAmount: secondaryBalanceString,
                                               secondaryCurrency: secondaryBalanceForCurrentIntput.currency.symbolPresentation.uppercased(),
                                               nextCurrencySwitchIsActive: nextCurrencySwitchIsActive,
                                               swapCurrenciesIsActive: swapCurrenciesIsActive, swapCurrenciesButtonStyle: swapButtonStyle,
                                               needsDecimalInput: needsDecimalInput,
                                               availableAmount: availableAmount)
    
    viewController.setViewModel(viewModel)
  }
  
  func handleNextStageAction() {    
    switch transactionType {
    case .invoice:
      nextStageActionHandling()
    case .outcoming:
      nextStageActionHandling()
    case .exchange:
      guard interactor.isCurrencySwapAvailable else {
        let curencies = currentCurrenciesPair
        viewController.showExchangeDirectionWarningAlert(WalletTransactionAmountPick.Strings.exchangeBackWarningTitle.localize(), message: WalletTransactionAmountPick.Strings.exchangeBackWarningMessage(main: curencies.main, secondary: curencies.secondary))
        return
      }
      
      nextStageActionHandling()
    }
  }
  
  func handleNextStageActionConfirmation() {
    nextStageActionHandling()
  }
  
  fileprivate var currentCurrenciesPair: (main: BalanceCurrency, secondary: BalanceCurrency) {
    switch currentInput {
    case .main:
      return (interactor.mainBalance.currency, interactor.secondaryBalance.currency)
    case .secondary:
      return (interactor.secondaryBalance.currency, interactor.mainBalance.currency)
    }
  }
  
  fileprivate func nextStageActionHandling() {
    switch transactionType {
    case .invoice:
      router.routeToInvoiceCreate(interactor.mainBalance, secondaryBalance: interactor.secondaryBalance)
    case .outcoming:
      router.routeToTransactionCreate(interactor.mainBalance, secondaryBalance: interactor.secondaryBalance)
    case .exchange:
      guard interactor.hasPinCode else {
        router.routeToPinCodeUnlock(delegate: self)
        return
      }
      
      interactor.performExchange(mainBalanceToSecondary: currentInput == .main)
    }
  }
  
  func handleSwapCurrencyAction() {
    guard interactor.isCurrencySwapAvailable else {
      return
    }
    
    interactor.switchInput()
  }
  
  func handleAmountChangedAction(_ value: String) {
    let numberFormatter = NumberFormatter()
    
    let amountValueString = value.count > 0 ? value : "0"
    guard let amount = numberFormatter.number(from: amountValueString)?.doubleValue else {
      presentNextStageAvailable(false)
      return
    }

    interactor.changeAmountTo(amount)
  }
  
  func handleHideAction() {
    router.dismiss()
  }
}

// MARK: - WalletRequestAmountPick Viper Components
fileprivate extension WalletTransactionAmountPickPresenter {
    var viewController: WalletTransactionAmountPickViewControllerApi {
        return _viewController as! WalletTransactionAmountPickViewControllerApi
    }
    var interactor: WalletTransactionAmountPickInteractorApi {
        return _interactor as! WalletTransactionAmountPickInteractorApi
    }
    var router: WalletTransactionAmountPickRouterApi {
        return _router as! WalletTransactionAmountPickRouterApi
    }
}

extension WalletTransactionAmountPickPresenter: WalletPinCodeUnlockDelegateProtocol {
  func walletDidUnlockWith(_ pinCode: String) {
    interactor.performExchange(mainBalanceToSecondary: currentInput == .main)
  }
  
  func walletDidFailToUnlock() {
    viewController.setNextStageButtonEnabled(true)
  }
}

//MARK:- Helpers

extension WalletTransactionAmountPickPresenter {
  fileprivate func presentUserProfile(_ profile: UserProtocol?, animated: Bool) {
    if _viewController == nil {
      return
    }
    
    switch interactor.transactionType {
    case .invoice:
      viewController.setProfile(nil, animated: animated)
    case .outcoming:
      viewController.setProfile(nil, animated: animated)
    case .exchange:
      guard let profile = profile else {
        viewController.setProfile(nil, animated: animated)
        return
      }
      
      let vm = WalletTransactionAmountPick.UserProfileViewModel(userProfile: profile)
      viewController.setProfile(vm, animated: animated)
    }
  }
  
  fileprivate func titleFor(_ type: WalletTransactionAmountPick.TransactionType) -> String {
    switch type {
    case .invoice:
      return WalletTransactionAmountPick.Strings.invoiceTitle.localize()
    case .outcoming:
      return WalletTransactionAmountPick.Strings.outcomingTitle.localize()
    case .exchange:
      switch currentInput {
      case .main:
        return WalletTransactionAmountPick.Strings.exhcanteTitle(from: interactor.mainBalance.currency, to: interactor.secondaryBalance.currency)
      case .secondary:
        return WalletTransactionAmountPick.Strings.exhcanteTitle(from: interactor.secondaryBalance.currency, to: interactor.mainBalance.currency)
      }
    }
  }
  
  fileprivate func navBarTitleFor(_ type: WalletTransactionAmountPick.TransactionType) -> String {
    switch type {
    case .invoice:
      return WalletTransactionAmountPick.Strings.invoiceNavBarTitle.localize()
    case .outcoming:
      return WalletTransactionAmountPick.Strings.outcomingNavBarTitle.localize()
    case .exchange:
      return WalletTransactionAmountPick.Strings.exchangeNavBarTitle.localize()
    }
  }
  
  fileprivate func nextStageButtonTitleFor(_ type: WalletTransactionAmountPick.TransactionType) -> String {
    switch type {
    case .invoice:
      return WalletTransactionAmountPick.Strings.nextButtonTitle.localize()
    case .outcoming:
      return WalletTransactionAmountPick.Strings.nextButtonTitle.localize()
    case .exchange:
      return WalletTransactionAmountPick.Strings.exchangeButtonTitle.localize()
    }
  }
}

extension WalletTransactionAmountPick {
  enum Strings: String, LocalizedStringKeyProtocol {
    case confirmExchangeAction = "Continue to exchange"
    case cancelExchangeAction = "Cancel"
    case invoiceTitle = "Request Amount"
    case outcomingTitle = "Send Amount"
    case invoiceNavBarTitle = "PIB Request"
    case outcomingNavBarTitle = "Send PIB"
    case exchangeNavBarTitle = "Exchange PIB"
    case nextButtonTitle = "Next"
    case exchangeButtonTitle = "Request"
    case exchangeBackWarningTitle = "Confirm"
    case exchangeTitle = "Request Exchange % to %"
    
    enum ExchangeBackWarningMessage: String, LocalizedStringKeyProtocol {
      case piblePGBExchangeWarning = "% is used to upvote users' posts."
      case exchangeWarning = "% can not be exchanged back to %."
    }
    
    static func exchangeBackWarningMessage(main: BalanceCurrency, secondary: BalanceCurrency) -> String {
      if main == .pibble && secondary == .greenBrush {
        let pgbInfo = ExchangeBackWarningMessage.piblePGBExchangeWarning.localize(value: secondary.symbol)
        let warning = ExchangeBackWarningMessage.exchangeWarning.localize(values: secondary.symbol, main.symbol)
        return "\(pgbInfo) \(warning)"
      }
      
      return ExchangeBackWarningMessage.exchangeWarning.localize(values: secondary.symbol, main.symbol)
    }
    
    static func exhcanteTitle(from: BalanceCurrency, to: BalanceCurrency) -> String {
      return Strings.exchangeTitle.localize(values: from.symbol, to.symbol)
    }
  }
}
