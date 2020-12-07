//
//  WalletRequestAmountInputViewModelProtocol.swift
//  Pibble
//
//  Created by Kazakov Sergey on 30.08.2018.
//  Copyright © 2018 com.kazai. All rights reserved.
//

import Foundation

protocol WalletRequestAmountInputViewModelProtocol {
  var title: String { get }
  var mainCurrencyAmount: String { get }
  var mainCurrency: String { get }
  
  var secondaryCurrencyAmount: String { get }
  var secondaryCurrency: String { get }
  
  var nextButtonTitle: String { get }
  var nextCurrencySwitchIsActive: Bool { get }
  var swapCurrenciesIsActive: Bool { get }
  var needsDecimalInput: Bool { get }
  var swapCurrenciesButtonStyle: SwapCurrenciesButtonStyle { get }
  
  var availableAmount: String? { get}
}
