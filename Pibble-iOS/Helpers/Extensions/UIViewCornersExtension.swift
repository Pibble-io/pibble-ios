//
//  UIViewCornersExtension.swift
//  Pibble
//
//  Created by Kazakov Sergey on 07.08.2018.
//  Copyright © 2018 com.kazai. All rights reserved.
//

import UIKit

extension UIView {
  func setCornersToCircle() {
    clipsToBounds = true
    layer.cornerRadius = bounds.width * 0.5
  }
  
  func setCornersToCircleByHeight() {
    clipsToBounds = true
    layer.cornerRadius = bounds.height * 0.5
  }
  
}
