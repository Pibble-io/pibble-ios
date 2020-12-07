//
//  WalletTransactionCurrencyPickInteractor.swift
//  Pibble-iOS
//
//  Created by Sergey Kazakov on 08/07/2019.
//Copyright © 2019 com.kazai. All rights reserved.
//

import Foundation 

// MARK: - WalletTransactionCurrencyPickInteractor Class
final class WalletTransactionCurrencyPickInteractor: Interactor {
  fileprivate let transaction: CreateExternalTransactionProtocol
  fileprivate let walletService: WalletServiceProtocol
  
  fileprivate var selectedCurrency: BalanceCurrency?
  
  fileprivate lazy var currencies: [BalanceCurrency] = {
    return transaction.coin.underlyingCurrencies
  }()
  
  init(walletService: WalletServiceProtocol, transaction: CreateExternalTransactionProtocol) {
    self.walletService = walletService
    self.transaction = transaction
  }
}

// MARK: - WalletTransactionCurrencyPickInteractor API
extension WalletTransactionCurrencyPickInteractor: WalletTransactionCurrencyPickInteractorApi {
  var initialCurrency: BalanceCurrency {
    return transaction.coin
  }
  
  func createTransaction() {
    guard let selectedCurrency = selectedCurrency else {
      return
    }
    
    let transactionToSend = WalletTransactionCurrencyPick.ExternalTransactionDraft(recipientAddress: transaction.recipientAddress,
                                                                      value: transaction.value,
                                                                      coin: selectedCurrency)
    walletService.createExternalTransaction(transaction: transactionToSend) { [weak self] in
      if let err = $0 {
        self?.presenter.handleError(err)
        self?.presenter.presentTransactionSentSuccefully(false)
        return
      }
      
      self?.presenter.presentTransactionSentSuccefully(true)
    }
  }
  
  var hasPinCode: Bool {
    return walletService.hasPinCode
  }
  
  func selectCurrencyAt(_ index: Int) {
    selectedCurrency = currencies[index]
    presenter.presentCurrencies(currencies,
                                selectedCurrency: selectedCurrency)
  }
  
  func initialFetchData() {
    presenter.presentCurrencies(currencies,
                                selectedCurrency: selectedCurrency)
  }
}

// MARK: - Interactor Viper Components Api
private extension WalletTransactionCurrencyPickInteractor {
  var presenter: WalletTransactionCurrencyPickPresenterApi {
    return _presenter as! WalletTransactionCurrencyPickPresenterApi
  }
}


//MARK:- Helpers

extension WalletTransactionCurrencyPickInteractor {
  var canSendTransaction: Bool {
    return selectedCurrency != nil
  }
}
