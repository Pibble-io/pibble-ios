//
//  UIViewAnimationExtestensions.swift
//  Pibble
//
//  Created by Sergey Kazakov on 06/07/2019.
//  Copyright © 2019 com.kazai. All rights reserved.
//

import UIKit

extension UIView {
  func fadeTransition(_ duration: CFTimeInterval) {
    let animation = CATransition()
    animation.timingFunction = CAMediaTimingFunction(name:
      CAMediaTimingFunctionName.easeInEaseOut)
    animation.type = CATransitionType.fade
    animation.duration = duration
    layer.add(animation, forKey: CATransitionType.fade.rawValue)
  }
}
