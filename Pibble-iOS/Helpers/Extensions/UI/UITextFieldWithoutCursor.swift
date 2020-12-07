//
//  UITextFieldWithoutCursor.swift
//  Pibble
//
//  Created by Kazakov Sergey on 20.06.2018.
//  Copyright © 2018 com.kazai. All rights reserved.
//

import UIKit

class UITextFieldWithoutCursor: UITextField {
  var deleteEventHandler: ((UITextFieldWithoutCursor) -> Void)?
  
  override public func deleteBackward() {
    if text == "" {
      // do something when backspace is tapped/entered in an empty text field
    }
    deleteEventHandler?(self)
    super.deleteBackward()
  }

  override func caretRect(for position: UITextPosition) -> CGRect {
    return CGRect.zero
  }
  
}
