//
//  WalletTransactionAmountPickInteractor.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 30.08.2018.
//Copyright © 2018 com.kazai. All rights reserved.
//

import Foundation 

// MARK: - WalletTransactionAmountPickInteractor Class
final class WalletTransactionAmountPickInteractor: Interactor {
  
  let currenciesPairs: [(BalanceCurrency, BalanceCurrency)]
  let transactionType: WalletTransactionAmountPick.TransactionType
  fileprivate var currentCurrencyIndex: Int = 0
  fileprivate let walletService: WalletServiceProtocol
  fileprivate let accountProfileService: AccountProfileServiceProtocol
  
  fileprivate(set) var mainBalance: Balance
  fileprivate(set) var secondaryBalance: Balance
  
  fileprivate var availableBalance: Balance {
    return Balance(currency: maxBalanceValueCurrency, value: maxBalanceValue)
  }
  
  fileprivate(set) var currentInput: WalletTransactionAmountPick.AmountInput = .main
  
  fileprivate var exchangeRate: Double = 1.0
  fileprivate let minBalanceValue: Double = 0.000001
  
  fileprivate var maxBalanceValueCurrency: BalanceCurrency {
    switch transactionType {
    case .invoice:
      return mainBalance.currency
    case .outcoming:
      return mainBalance.currency
    case .exchange:
      return currentInput == .main ? mainBalance.currency: secondaryBalance.currency
    }
  }
  
  fileprivate var maxBalanceValue: Double {
    switch transactionType {
    case .invoice:
      return walletService.maxInvoiceAmountFor(mainBalance.currency)
    case .outcoming:
      guard let account = accountProfileService.currentUserAccount else {
        return 0.0
      }
      
      return walletService.maxOutcomingAmountFor(account, currency: mainBalance.currency)
    case .exchange:
      guard let account = accountProfileService.currentUserAccount else {
        return 0.0
      }
      
      return currentInput == .main ?
        walletService.maxExchangeAmountFor(account, currency: mainBalance.currency):
        walletService.maxExchangeAmountFor(account, currency: secondaryBalance.currency)
    }
  }
  
  init(walletService: WalletServiceProtocol, accountProfileService: AccountProfileServiceProtocol, transactionType: WalletTransactionAmountPick.TransactionType) {
    
    self.transactionType = transactionType
    switch transactionType {
    case .invoice(let main, let secondary):
      mainBalance = Balance(currency: main.first!, value: 0.0)
      secondaryBalance = Balance(currency: secondary, value: 0.0)
      currenciesPairs = main.map { ($0, secondary) }
    case .outcoming(let main, let secondary):
      mainBalance = Balance(currency: main.first!, value: 0.0)
      secondaryBalance = Balance(currency: secondary, value: 0.0)
      currenciesPairs = main.map { ($0, secondary) }
    case .exchange(let currencyPairs):
      let firstPair = currencyPairs.first!
      mainBalance = Balance(currency: firstPair.main, value: 0.0)
      secondaryBalance = Balance(currency: firstPair.secondary, value: 0.0)
      currenciesPairs = currencyPairs.map { ($0.main, $0.secondary) }
    }
    
    self.walletService = walletService
    self.accountProfileService = accountProfileService
  }
}

// MARK: - WalletTransactionAmountPickInteractor API
extension WalletTransactionAmountPickInteractor: WalletTransactionAmountPickInteractorApi {
  var userProfile: UserProtocol? {
    return accountProfileService.currentUserAccount
  }
  
  var isCurrencySwapAvailable: Bool {
    switch transactionType {
    case .invoice:
      return true
    case .outcoming:
      return true
    case .exchange(let currencyPairs):
      return !currencyPairs[currentCurrencyIndex].oneWay
    }
  }
  
  var mainCurrencies: [BalanceCurrency] {
    return currenciesPairs.map { $0.0 }
  }
  
  func performSwitchToNextMainCurrency() {
    currentInput = .main
    
    var nextIdx = currentCurrencyIndex + 1
    if nextIdx >= currenciesPairs.count {
      nextIdx = 0
    }
    
    guard nextIdx < currenciesPairs.count else {
      return
    }
    currentCurrencyIndex = nextIdx
    
    let newMainCurrency = currenciesPairs[nextIdx].0
    mainBalance = Balance(currency: newMainCurrency, value: mainBalance.value)
    
    let newSecondaryCurrency = currenciesPairs[nextIdx].1
    secondaryBalance = Balance(currency: newSecondaryCurrency, value: secondaryBalance.value)
    
    exchangeRate = 1.0
    
    changeMainAmountTo(mainBalance.value)
    walletService.exchangeRate(mainBalance.currency, to: secondaryBalance.currency) { [weak self] in
      switch $0 {
      case .success(let exchangeRate):
        if let value = exchangeRate.rateDoubleValue {
          self?.exchangeRate = value
        }
      case .failure(let err):
        self?.presenter.handleError(err)
      }
    }
  }
  
  var hasPinCode: Bool {
    return walletService.hasPinCode
  }
  
  func performExchange(mainBalanceToSecondary: Bool) {
    presenter.presentNextStageAvailable(false)
    let from = mainBalanceToSecondary ? mainBalance.currency : secondaryBalance.currency
    let to = !mainBalanceToSecondary ? mainBalance.currency : secondaryBalance.currency
    let value = mainBalanceToSecondary ? mainBalance.value : secondaryBalance.value
    walletService.createExchangeTransaction(from, to: to, value: value) { [weak self] in
      if let error = $0 {
        self?.presenter.handleError(error)
        return
      }
      
      self?.presenter.presentExchangeSuccess()
    }
  }
  
  func initialFetchData() {
    exchangeRate = 1.0
    changeMainAmountTo(0.0)
    walletService.exchangeRate(mainBalance.currency, to: secondaryBalance.currency) { [weak self] in
      switch $0 {
      case .success(let exchangeRate):
        if let value = exchangeRate.rateDoubleValue {
          self?.exchangeRate = value
        }
      case .failure(let err):
        self?.presenter.handleError(err)
      }
    }
    
    accountProfileService.getProfile { [weak self] in
      guard let strongSelf = self else {
        return
      }
      switch $0 {
      case .success(let userProfile):
        strongSelf.validateMainBalanceValue()
        strongSelf.presenter.presentUserProfile(userProfile)
      case .failure(let err):
        strongSelf.presenter.handleError(err)
      }
    }
  }
  
  func switchInput() {
    currentInput = currentInput.switchedInput()
    
    switch currentInput {
    case .main:
      changeMainAmountTo(secondaryBalance.value)
    case .secondary:
      changeSecondaryAmountTo(mainBalance.value)
    }
  }
  
  func changeAmountTo(_ value: Double) {
    switch currentInput {
    case .main:
      changeMainAmountTo(value)
    case .secondary:
      changeSecondaryAmountTo(value)
    }
  }
  
  fileprivate func changeMainAmountTo(_ value: Double) {
    mainBalance.value = value
    secondaryBalance.value = value * exchangeRate
    validateMainBalanceValue()
    presenter.present(mainBalance: mainBalance, secondaryBalance: secondaryBalance, availableBalance: availableBalance)
  }
  
  fileprivate func changeSecondaryAmountTo(_ value: Double) {
    mainBalance.value = value * (1.0 / exchangeRate)
    secondaryBalance.value = value
    validateMainBalanceValue()
    presenter.present(mainBalance: mainBalance, secondaryBalance: secondaryBalance, availableBalance: availableBalance)
  }
  
  fileprivate func validateMainBalanceValue() {
    presenter.presentNextStageAvailable(minBalanceValue.isLessThanOrEqualTo(mainBalance.value) && mainBalance.value.isLessThanOrEqualTo(maxBalanceValue))
  }
}

// MARK: - Interactor Viper Components Api
private extension WalletTransactionAmountPickInteractor {
    var presenter: WalletTransactionAmountPickPresenterApi {
        return _presenter as! WalletTransactionAmountPickPresenterApi
    }
}
