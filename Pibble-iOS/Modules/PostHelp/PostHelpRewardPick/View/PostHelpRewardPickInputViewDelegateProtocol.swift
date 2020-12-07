//
//  PostHelpRewardPickInputViewDelegateProtocol.swift
//  Pibble
//
//  Created by Kazakov Sergey on 09.01.2019.
//  Copyright © 2019 com.kazai. All rights reserved.
//

import Foundation

protocol PostHelpRewardPickInputViewDelegateProtocol: class {
  func handleChangeValueToMin()
  func handleChangeValueToMax()
}

protocol PostHelpRewardPickTextFieldInputViewDelegateProtocol: PostHelpRewardPickInputViewDelegateProtocol {
  func handleChangeValue(_ value: String)
  func handleDidEndEditing()
}
