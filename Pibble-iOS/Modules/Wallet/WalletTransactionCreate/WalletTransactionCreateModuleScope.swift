//
//  WalletTransactionCreateModuleScope.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 10.09.2018.
//Copyright © 2018 com.kazai. All rights reserved.
//

import Foundation

enum WalletTransactionCreate {
  enum SelectedUsersSegment {
    case friends
    case recentFriends
  }
  
  enum SelectedSegment {
    case users
    case address
    case pickQRCode
  }
  
  enum TransactionType {
    case internalTransaction(UserProtocol?)
    case externalTransaction(String)
  }
  
  struct InternalTransactionDraft: CreateInternalTransactionProtocol {
    let recipientUUID: String
    let value: Double
    let coin: BalanceCurrency
  }
  
  struct ExternalTransactionDraft: CreateExternalTransactionProtocol {
    let recipientAddress: String
    let value: Double
    let coin: BalanceCurrency
  }
}
