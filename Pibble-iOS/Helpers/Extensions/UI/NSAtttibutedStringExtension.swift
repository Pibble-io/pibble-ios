//
//  NSAtttibutedStringExtension.swift
//  Pibble
//
//  Created by Kazakov Sergey on 13.08.2018.
//  Copyright © 2018 com.kazai. All rights reserved.
//

import UIKit

extension NSAttributedString {
  func heightThatFitsIn(_ label: UILabel) -> CGFloat {
    let size = boundingRect(with: CGSize(width: label.bounds.width, height: 9999), options: [NSStringDrawingOptions.usesLineFragmentOrigin, NSStringDrawingOptions.usesFontLeading], context: nil)
    return ceil(size.height)
  }
  
}
