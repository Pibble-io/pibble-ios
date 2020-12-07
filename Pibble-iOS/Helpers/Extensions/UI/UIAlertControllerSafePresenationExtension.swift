//
//  AlertController.swift
//  Pibble
//
//  Created by Sergey Kazakov on 15/05/2019.
//  Copyright © 2019 com.kazai. All rights reserved.
//

import UIKit

extension UIAlertController {
  convenience init(title: String?, message: String?, safelyPreferredStyle: UIAlertController.Style) {
    let style: UIAlertController.Style
    switch safelyPreferredStyle {
    case .actionSheet:
      style = UIDevice.current.userInterfaceIdiom == .phone ? .actionSheet : .alert
    case .alert:
      style = .alert
    }
    
    self.init(title: title, message: message, preferredStyle: style)
  }
}
