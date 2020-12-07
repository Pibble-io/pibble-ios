//
//  StringSizeForTextExtension.swift
//  Pibble
//
//  Created by Kazakov Sergey on 25.07.2018.
//  Copyright © 2018 com.kazai. All rights reserved.
//

import UIKit

extension String {
  func heightWithConstrainedWidth(width: CGFloat, font: UIFont) -> CGFloat {
    let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
    let boundingBox = self.boundingRect(with: constraintRect, options: [.usesLineFragmentOrigin, .usesFontLeading], attributes: [NSAttributedString.Key.font: font], context: nil)
    return boundingBox.height
  }
  
  func widthWithConstrainedHeight(height: CGFloat, font: UIFont) -> CGFloat {
    let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
    let boundingBox = self.boundingRect(with: constraintRect, options: [.usesLineFragmentOrigin, .usesFontLeading], attributes: [NSAttributedString.Key.font: font], context: nil)
    return boundingBox.width
  }
}
