//
//  BackgroundGradient.swift
//  Pibble
//
//  Created by Kazakov Sergey on 18.06.2018.
//  Copyright © 2018 com.kazai. All rights reserved.
//

import UIKit

class GradientView: UIView {
  fileprivate var insertedGradientLayer: CAGradientLayer?
  
  enum GradientDirections {
    case horizontal
    case vertical
    case diagonalLeft
    case diagonalRight
    
    var startPoint: CGPoint {
      switch self {
      case .horizontal:
        return CGPoint(x: 0.0, y: 0.0)
      case .vertical:
        return CGPoint(x: 0.0, y: 0.0)
      case .diagonalLeft:
        return CGPoint(x: 0.0, y: 0.0)
      case .diagonalRight:
        return CGPoint(x: 1.0, y: 0.0)
      }
    }
    
    var endPoint: CGPoint {
      switch self {
      case .horizontal:
        return CGPoint(x: 1.0, y: 0.0)
      case .vertical:
        return CGPoint(x: 0.0, y: 1.0)
      case .diagonalLeft:
        return CGPoint(x: 1.0, y: 1.0)
      case .diagonalRight:
        return CGPoint(x: 0.0, y: 1.0)
      }
    }
  }
  
  override func draw(_ rect: CGRect) {
    super.draw(rect)
    insertedGradientLayer?.frame = bounds
  }
  
  func addBackgroundGradientWith(_ colors: [UIColor], direction: GradientDirections) {
    let gradientColors: [CGColor] =  colors.map { return $0.cgColor}
    
    let gradientLayer = CAGradientLayer()
    gradientLayer.colors = gradientColors
    gradientLayer.startPoint = direction.startPoint
    gradientLayer.endPoint = direction.endPoint
    
    gradientLayer.frame = bounds
    
    layer.insertSublayer(gradientLayer, at: 0)
    insertedGradientLayer = gradientLayer
  }
}
