//
//  ShadowExtensions.swift
//  Pibble
//
//  Created by Kazakov Sergey on 19.06.2018.
//  Copyright © 2018 com.kazai. All rights reserved.
//

import UIKit
extension UIView {
  
 

  func addShadow(shadowColor: UIColor, offSet: CGSize, opacity: Float, radius: CGFloat) {
    layer.shadowColor = shadowColor.cgColor
    layer.shadowOffset = offSet
    layer.shadowOpacity = opacity
    layer.shadowRadius = radius
    layer.shouldRasterize = true
    layer.rasterizationScale = UIScreen.main.scale
    layer.masksToBounds = false

  }
}

extension UIView {
  func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
    let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
    let mask = CAShapeLayer()
    mask.path = path.cgPath
    layer.mask = mask
  }
}
