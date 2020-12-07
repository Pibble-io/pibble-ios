//
//  UICorneredView.swift
//  Pibble
//
//  Created by Sergey Kazakov on 20/06/2019.
//  Copyright © 2019 com.kazai. All rights reserved.
//

import UIKit

class UICorneredView: UIView {
  var cornersToRound: UIRectCorner?
  var radius: CGFloat = 0.0
  
  override func layoutSubviews() {
    super.layoutSubviews()
    if let corners = cornersToRound {
      roundCorners(corners: corners, radius: radius)
    }
  }
}

extension UIView {
  func roundCorners(corners: UIRectCorner, radius: CGFloat) {
    let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
    let mask = CAShapeLayer()
    mask.path = path.cgPath
    layer.mask = mask
  }
}
