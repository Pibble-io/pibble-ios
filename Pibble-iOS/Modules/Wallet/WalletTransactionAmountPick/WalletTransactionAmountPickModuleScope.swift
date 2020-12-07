//
//  WalletRequestAmountPickModuleScope.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 30.08.2018.
//Copyright © 2018 com.kazai. All rights reserved.
//

import UIKit

enum WalletTransactionAmountPick {
  enum TransactionType {
    case invoice(main: [BalanceCurrency], secondary: BalanceCurrency)
    case outcoming(main: [BalanceCurrency], secondary: BalanceCurrency)
    case exchange(currencyPairs: [(main: BalanceCurrency, secondary: BalanceCurrency, oneWay: Bool)])
  }
  
  enum AmountInput {
    case main
    case secondary
    
    func switchedInput() -> AmountInput {
      switch self {
      case .main:
        return .secondary
      case .secondary:
        return .main
      }
    }
  }
  
  struct UserProfileViewModel: WalletProfileHeaderViewModelProtocol {
    let userpicUrlString: String
    let userpicPlaceholder: UIImage?
    let username: String
    let pibbleBalance: String

    let greenBrushBalance: String
    let redBrushBalance: String
    
    let balances: [(currency: String, balance: String)]
    
    init(userProfile: UserProtocol) {
      username = userProfile.userName.capitalized
      userpicUrlString = userProfile.userpicUrlString
      userpicPlaceholder = UIImage.avatarImageForNameString(userProfile.userName)
      
      let pibbleValue = userProfile.walletBalances.first { $0.currency == BalanceCurrency.pibble }?.value ?? 0.0
      let greenBrushValue = userProfile.walletBalances.first { $0.currency == BalanceCurrency.greenBrush }?.value ?? 0.0
      let redBrushValue = userProfile.walletBalances.first { $0.currency == BalanceCurrency.redBrush }?.value ?? 0.0
      let ethValue = userProfile.walletBalances.first { $0.currency == BalanceCurrency.etherium }?.value ?? 0.0
      let btcValue = userProfile.walletBalances.first { $0.currency == BalanceCurrency.bitcoin }?.value ?? 0.0
      
      pibbleBalance = String(format:"%.1f", pibbleValue)
      greenBrushBalance = String(format:"%.1f", greenBrushValue)
      redBrushBalance = String(format:"%.1f", redBrushValue)
      
      let ethBalance = String(format:"%.3f", ethValue)
      let btcBalance = String(format:"%.8f", btcValue)
      
      let pibbleBalanceCurrency = BalanceCurrency.pibble.symbol.uppercased()
      let ethBalanceCurrency = BalanceCurrency.etherium.symbol.uppercased()
      let btcBalanceCurrency = BalanceCurrency.bitcoin.symbol.uppercased()
      
      balances = [(pibbleBalanceCurrency, pibbleBalance),
                  (ethBalanceCurrency, ethBalance),
                  (btcBalanceCurrency, btcBalance)]
    }
  }
}
