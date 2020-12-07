//
//  WalletPinCodeModuleScope.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 12.09.2018.
//Copyright © 2018 com.kazai. All rights reserved.
//

import Foundation

enum WalletPinCode {
  enum PinCodePurpose {
    case registerNewPinCode
    case confirmNewPinCode(String)
    case unlock
    case restorePinCode(token: String)
    case confirmRestorePinCode(token: String, pinCode: String)
  }
  
  enum ControlActions {
    case left
    case digitSelect
    case right
  }
  
  enum DigitItemType {
    case digit(DigitViewModelProtocol)
    case digitWithControls(DigitWithControlsViewModelProtocol)
  }
  
  enum Digit {
    case digit(Int)
    case digitWithControls(Int)
    
    var value: Int {
      switch self {
      case .digit(let valueInt):
        return valueInt
      case .digitWithControls(let valueInt):
        return valueInt
      }
    }
  }
}
