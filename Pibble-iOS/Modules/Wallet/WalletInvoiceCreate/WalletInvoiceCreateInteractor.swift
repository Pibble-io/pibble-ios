//
//  WalletInvoiceCreateInteractor.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 31.08.2018.
//Copyright © 2018 com.kazai. All rights reserved.
//

import Foundation 

// MARK: - WalletInvoiceCreateInteractor Class
final class WalletInvoiceCreateInteractor: Interactor {
  fileprivate let walletService: WalletServiceProtocol
  fileprivate let coreDataStorageService: CoreDataStorageServiceProtocol
  fileprivate let mainAmountBalance: Balance
  fileprivate let secondaryAmountBalance: Balance
  fileprivate var invoiceDescription: String = ""
  
  var invoiceRecipientUser: UserProtocol? {
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
    return invoiceRecipientUser != nil
  }
}

// MARK: - WalletInvoiceCreateInteractor API
extension WalletInvoiceCreateInteractor: WalletInvoiceCreateInteractorApi {
  func createInvoice() {
    guard canPostInvoice else {
      return
    }
    
    guard let user = invoiceRecipientUser else {
      return
    }

    let invoiceDraft = WalletInvoiceCreate.InvoiceDraft(recipientUUID: user.userUUID,
                                     value: mainAmountBalance.value,
                                     coin: mainAmountBalance.currency,
                                     description: invoiceDescription)
    
    
    walletService.createInvoice(invoice: invoiceDraft) { [weak self] in
      switch $0 {
      case .success(let invoice):
        self?.coreDataStorageService.updateStorage(with: [invoice])
        self?.presenter.presentInvoiceSentSuccefully(true)
      case .failure(let error):
        self?.presenter.handleError(error)
        self?.presenter.presentInvoiceSentSuccefully(false)
      }
    }
  }
  
  
  func updateDescriptionWith(_ value: String) {
    invoiceDescription = value.cleanedFromExtraNewLines()
    presenter.presentCreateInvoiceEnabled(canPostInvoice)
  }
  
  func initialFetchData() {
    presenter.presentCreateInvoiceEnabled(canPostInvoice)
    presenter.present(mainBalance: mainAmountBalance, secondaryBalance: secondaryAmountBalance)
  }
  
}

// MARK: - Interactor Viper Components Api
private extension WalletInvoiceCreateInteractor {
    var presenter: WalletInvoiceCreatePresenterApi {
        return _presenter as! WalletInvoiceCreatePresenterApi
    }
}
