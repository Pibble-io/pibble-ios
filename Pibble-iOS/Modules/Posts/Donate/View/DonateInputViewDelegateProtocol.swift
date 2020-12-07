//
//  DonateInputViewDelegateProtocol.swift
//  Pibble
//
//  Created by Kazakov Sergey on 10.01.2019.
//  Copyright © 2019 com.kazai. All rights reserved.
//

import Foundation


protocol DonateInputViewDelegateProtocol: class {
  func handleChangeValueToMin()
  func handleChangeValueToMax()
  func handleCurrencySwitch()
}

protocol DonateTextFieldInputViewDelegateProtocol: DonateInputViewDelegateProtocol {
  func handleChangeValue(_ value: String)
  func handleDidEndEditing()
}

protocol DonateSliderInputViewDelegateProtocol: DonateInputViewDelegateProtocol {
  func handleChangeValue(_ value: Float)
  func handleDirectInputAction()
}
