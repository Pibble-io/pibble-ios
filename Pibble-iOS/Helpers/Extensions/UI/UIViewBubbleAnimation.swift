//
//  UIViewBubbleAnimation.swift
//  Pibble
//
//  Created by Sergey Kazakov on 02/03/2019.
//  Copyright © 2019 com.kazai. All rights reserved.
//

import UIKit

extension UIView {
  func bubbleAnimate(duration: TimeInterval = 0.15, scale: CGFloat = 1.25, delay: TimeInterval = 0.0) {
    UIView.animate(withDuration: duration,
                   delay: delay,
                   options: .curveLinear,
                   animations: { [weak self] in
                    self?.transform = CGAffineTransform(scaleX: scale, y: scale)
    }) { (_) in
      UIView.animate(withDuration: duration, animations: { [weak self] in
        self?.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
      }) { (_) in  }
    }
  }
  
  func bubbleAnimateWithAppearance(duration: TimeInterval = 0.15,
                                   
                                   scale: CGFloat = 1.25,
                                   hideDuration: TimeInterval = 0.15,
                                   hideDelay: TimeInterval = 0.0) {
    
    UIView.animate(withDuration: duration, delay: 0.0, usingSpringWithDamping: 0.65, initialSpringVelocity: 0.0, options: .curveLinear, animations: { [weak self] in
//    UIView.animate(withDuration: duration,
//                   delay: 0.0,
//                   options: .curveLinear,
//                   animations: { [weak self] in
      self?.alpha = 1.0
      self?.transform = CGAffineTransform(scaleX: scale, y: scale)
    }) { (_) in
      UIView.animate(withDuration: hideDuration,
                     delay: hideDelay,
                     options: .curveLinear,
                     animations: { [weak self] in
                      self?.alpha = 0.0
                      self?.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
      }) { (_) in  }
    }
    
//
//    UIView.animate(withDuration: duration,
//                   delay: 0.0,
//                   options: .curveLinear,
//                   animations: { [weak self] in
//                    self?.alpha = 1.0
//                    self?.transform = CGAffineTransform(scaleX: scale, y: scale)
//    }) { (_) in
//
//      UIView.animate(withDuration: duration,
//                     delay: delay,
//                     options: .curveLinear,
//                     animations: { [weak self] in
//                      self?.alpha = 0.0
//                      self?.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
//      }) { (_) in  }
//
//    }
  }
  
}
