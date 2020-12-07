//
//  WalletRequestAmountInputViewModel.swift
//  Pibble
//
//  Created by Kazakov Sergey on 30.08.2018.
//  Copyright © 2018 com.kazai. All rights reserved.
//

import Foundation

enum SwapCurrenciesButtonStyle {
  case prb
  case pgb
  case white
}

extension Wallet {
  struct WalletRequestAmountInputViewModel: WalletRequestAmountInputViewModelProtocol {
    let nextButtonTitle: String
    let title: String
    let mainCurrencyAmount: String
    let mainCurrency: String
    let secondaryCurrencyAmount: String
    let secondaryCurrency: String
    let nextCurrencySwitchIsActive: Bool
    let swapCurrenciesIsActive: Bool
    let swapCurrenciesButtonStyle: SwapCurrenciesButtonStyle
    let needsDecimalInput: Bool
    
    let availableAmount: String?
    
  }
}
