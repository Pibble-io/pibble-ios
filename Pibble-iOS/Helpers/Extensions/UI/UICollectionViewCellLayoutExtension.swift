//
//  UICollectionViewCellLayoutExtension.swift
//  Pibble
//
//  Created by Kazakov Sergey on 02.07.2018.
//  Copyright © 2018 com.kazai. All rights reserved.
//

import UIKit

extension UICollectionViewCell {
  func setLayoutDurationFor(_ indexPath: IndexPath) {
    let originalAnimationDuration = CATransaction.animationDuration()
    let newAnimationDuration = min(0.25, 0.15 + (Double(indexPath.item) * 0.02))
    layer.speed = Float(originalAnimationDuration / newAnimationDuration)
  }
}
