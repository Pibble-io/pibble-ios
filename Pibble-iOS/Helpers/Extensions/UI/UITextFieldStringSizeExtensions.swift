//
//  UITextFieldStringSizeExtensions.swift
//  Pibble
//
//  Created by Kazakov Sergey on 25.07.2018.
//  Copyright © 2018 com.kazai. All rights reserved.
//

import UIKit

extension UITextField {
  func widthForText() -> CGFloat {
    let caretX = caretRect(for: endOfDocument).minX
    let widthForText = max(0.0, caretX)
    return min(bounds.width, widthForText)
  }
  
  func setAttrubutedTextPlaceholder(_ string: String) {
      let attributedString = NSMutableAttributedString(string: string)

//      var attributes: [NSAttributedStringKey: Any] = [:]
//      defaultTextAttributes.forEach {
//        attributes[NSAttributedStringKey(rawValue: $0.0)] = $0.1
//      }
//
//      attributedString.addAttributes(attributes, range: NSRange(location: 0, length: attributedString.string.count))
//
//      attributedPlaceholder = attributedString

        if let font = font {
          attributedString.addAttribute(NSAttributedString.Key.font, value: font, range: NSMakeRange(0, attributedString.string.count))
        }
        if let color = textColor {
          attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: color, range: NSMakeRange(0, attributedString.string.count))
        }
    
        attributedPlaceholder = attributedString
  }
}
