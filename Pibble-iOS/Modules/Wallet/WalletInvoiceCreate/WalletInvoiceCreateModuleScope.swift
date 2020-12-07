//
//  WalletInvoiceCreateModuleScope.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 31.08.2018.
//Copyright © 2018 com.kazai. All rights reserved.
//

import Foundation

enum WalletInvoiceCreate {
  enum SelectedSegment {
    case friends
    case recentFriends
  }
  
  struct InvoiceDraft: CreateInvoiceProtocol {
    let recipientUUID: String
    let value: Double
    let coin: BalanceCurrency
    let description: String
  }
}
