//
//  UpVoteInputViewDelegateProtocol.swift
//  Pibble
//
//  Created by Kazakov Sergey on 09.01.2019.
//  Copyright © 2019 com.kazai. All rights reserved.
//

import Foundation

protocol UpVoteInputViewDelegateProtocol: class {
  func handleChangeValueToMin()
  func handleChangeValueToMax()
}

protocol UpVoteTextFieldInputViewDelegateProtocol: UpVoteInputViewDelegateProtocol {
  func handleChangeValue(_ value: String)
  func handleDidEndEditing()
}

protocol UpVoteSliderInputViewDelegateProtocol: UpVoteInputViewDelegateProtocol {
  func handleChangeValue(_ value: Float)
  func handleDirectInputAction()
}
