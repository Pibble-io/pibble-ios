//
//  UIViewShakeExtensions.swift
//  Pibble
//
//  Created by Kazakov Sergey on 13.09.2018.
//  Copyright © 2018 com.kazai. All rights reserved.
//

import UIKit

extension UIView {
  func shake(count: Int = 4, duration: TimeInterval = 0.06, offset: CGFloat = 10) {
    let midX = center.x
    let midY = center.y
    
    let animation = CABasicAnimation(keyPath: "position")
    animation.duration = duration
    animation.repeatCount = Float(count)
    animation.autoreverses = true
    animation.fromValue = CGPoint(x: midX - offset, y: midY)
    animation.toValue = CGPoint(x: midX + offset, y: midY)
    layer.add(animation, forKey: "position")
  }
}
