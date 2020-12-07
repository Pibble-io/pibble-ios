//
//  WalletTransactionCurrencyPickModuleScope.swift
//  Pibble-iOS
//
//  Created by Sergey Kazakov on 08/07/2019.
//Copyright © 2019 com.kazai. All rights reserved.
//

import Foundation

enum WalletTransactionCurrencyPick {
  struct ItemViewModel: WalletTransactionCurrencyPickItemViewModelProtocol {
    let isSelected: Bool
    let title: String
  }
  
  struct ExternalTransactionDraft: CreateExternalTransactionProtocol {
    let recipientAddress: String
    let value: Double
    let coin: BalanceCurrency
  }
}

extension WalletTransactionCurrencyPick {
  enum Strings: String, LocalizedStringKeyProtocol {
    case title = "Select % Chain"
    
    enum Warning: String, LocalizedStringKeyProtocol {
      case warningTitle = "Warning:"
      case warningSubtitle = "If you incorrectly set the chain of the PIB address to be sent, the PIB token may be locked for a long time or even lost."
    }
  }
}
