//
//  UIViewFlipExtension.swift
//  Pibble
//
//  Created by Sergey Kazakov on 15/03/2019.
//  Copyright © 2019 com.kazai. All rights reserved.
//

import UIKit

extension UIView {
  func flipUpsideDown() {
    transform = CGAffineTransform(scaleX: 1, y: -1)
  }
}
