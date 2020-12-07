//
//  WalletTransactionCreateInteractor.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 10.09.2018.
//Copyright © 2018 com.kazai. All rights reserved.
//

import Foundation 

// MARK: - WalletTransactionCreateInteractor Class
final class WalletTransactionCreateInteractor: Interactor {
  fileprivate let walletService: WalletServiceProtocol
  fileprivate let coreDataStorageService: CoreDataStorageServiceProtocol
  fileprivate let mainAmountBalance: Balance
  fileprivate let secondaryAmountBalance: Balance
  
  fileprivate var transactionType: WalletTransactionCreate.TransactionType? {
    didSet {
      presenter.presentCreateInvoiceEnabled(canPostInvoice)
    }
  }
  
  init(walletService: WalletServiceProtocol,
       coreDataStorageService: CoreDataStorageServiceProtocol,
       mainAmountBalance: Balance,
       secondaryAmountBalance: Balance) {
    self.walletService = walletService
    self.coreDataStorageService = coreDataStorageService
    self.mainAmountBalance = mainAmountBalance
    self.secondaryAmountBalance = secondaryAmountBalance
  }
  
  fileprivate var canPostInvoice: Bool {
    guard let transactionType = transactionType else {
      return false
    }
    
    switch transactionType {
    case .internalTransaction(let user):
      guard let _ = user else {
        return false
      }
    case .externalTransaction(let address):
      guard address.count > 0 else {
        return false
      }
    }
    
//    guard let pinCode = pinCode else {
//      return false
//    }
    
    return true
  }
}

// MARK: - WalletTransactionCreateInteractor API
extension WalletTransactionCreateInteractor: WalletTransactionCreateInteractorApi {
  var externalTransaction: CreateExternalTransactionProtocol? {
    guard let transactionType = transactionType else {
      return nil
    }
    
    switch transactionType {
    case .internalTransaction(_):
      return nil
    case .externalTransaction(let address):
      let transaction = WalletTransactionCreate.ExternalTransactionDraft(recipientAddress: address,
                                                                         value: mainAmountBalance.value,
                                                                         coin: mainAmountBalance.currency)
      
      return transaction
    }
  }
  
  var shouldPickCurrencyForTransaction: Bool {
    guard let transactionType = transactionType else {
      return false
    }
    
    switch transactionType {
    case .internalTransaction(_):
      return false
    case .externalTransaction(_):
      return mainCurrency.hasUnderlyingCurrencies
    }
  }
  
  var mainCurrency: BalanceCurrency {
    return mainAmountBalance.currency
  }
  
  var invoiceRecipientUser: UserProtocol? {
    get {
      guard let selectedTransactionType = transactionType else {
        return nil
      }
      
      guard case let WalletTransactionCreate.TransactionType.internalTransaction(user) = selectedTransactionType else {
        return nil
      }
      
      return user
    }
    
    set {
      transactionType = .internalTransaction(newValue)
    }
  }
  var hasPinCode: Bool {
    return walletService.hasPinCode
  }
  
  func resetPickedRecipient() {
    transactionType = nil
  }
  
  func setRecipientAddress(_ value: String) {
    let trimmedAddress = value.trimmingCharacters(in: .whitespacesAndNewlines)
    transactionType = .externalTransaction(trimmedAddress)
  }
  
  func createTransaction() {
    guard canPostInvoice else {
      return
    }
    
    guard let transactionType = transactionType else {
      return
    }
   
    switch transactionType {
    case .internalTransaction(let user):
      guard let user = user else {
        return
      }
      
      let transaction = WalletTransactionCreate
        .InternalTransactionDraft(recipientUUID: user.userUUID,
                                  value: mainAmountBalance.value,
                                  coin: mainAmountBalance.currency)
      AppLogger.debug("createInternalTransaction")
      walletService.createInternalTransaction(transaction: transaction) { [weak self] in
        if let err = $0 {
          self?.presenter.handleError(err)
          self?.presenter.presentInvoiceSentSuccefully(false)
          return
        }
       
        self?.presenter.presentInvoiceSentSuccefully(true)
      }
    case .externalTransaction(let address):
      AppLogger.debug("externalTransaction")
      let transaction = WalletTransactionCreate.ExternalTransactionDraft(recipientAddress: address,
                                                       value: mainAmountBalance.value,
                                                       coin: mainAmountBalance.currency)
      
      
      walletService.createExternalTransaction(transaction: transaction) { [weak self] in
        if let err = $0 {
          self?.presenter.handleError(err)
          self?.presenter.presentInvoiceSentSuccefully(false)
          return
        }
        
        self?.presenter.presentInvoiceSentSuccefully(true)
      }
    }
  }
 
  func setInvoiceRecipientUser(_ user: UserProtocol?) {
    transactionType = .internalTransaction(user)
  }
 
  
  func initialFetchData() {
    presenter.presentCreateInvoiceEnabled(canPostInvoice)
    presenter.present(mainBalance: mainAmountBalance, secondaryBalance: secondaryAmountBalance)
    presenter.presentSelectedTransactionType(transactionType)
  }
  
}

// MARK: - Interactor Viper Components Api
private extension WalletTransactionCreateInteractor {
  var presenter: WalletTransactionCreatePresenterApi {
    return _presenter as! WalletTransactionCreatePresenterApi
  }
}
