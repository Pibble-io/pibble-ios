//
//  UIButtonExtensions.swift
//  Pibble
//
//  Created by Sergey Kazakov on 06/05/2019.
//  Copyright © 2019 com.kazai. All rights reserved.
//

import UIKit

extension UIButton {
  func setTitleForAllStates(_ title: String) {
    let states: [UIControl.State] = [.normal, .highlighted, .selected, .disabled]
    states.forEach {
      setTitle(title, for: $0)
    }
  }
}
