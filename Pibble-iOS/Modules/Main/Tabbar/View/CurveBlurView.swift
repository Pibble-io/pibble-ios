//
//  CurveBlurView.swift
//  Pibble
//
//  Created by Kazakov Sergey on 29.07.2018.
//  Copyright © 2018 com.kazai. All rights reserved.
//

import UIKit
import VisualEffectView

enum CurveBlurViewPath {
  case initial
  case extended
  case middle
  case middleUp
}
class CurveBlurView: VisualEffectView {
  fileprivate var animationCompleteBlock: ((Bool) -> Void)?
  fileprivate let maskLayer: CAShapeLayer = {
    let layer = CAShapeLayer()
    
    return layer
  }()
 
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    commonInit()
  }
  
  private func commonInit() {
    layer.mask = maskLayer
    maskLayer.frame = bounds
    setPath(.initial)
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    maskLayer.frame = bounds
  //  setPath(.initial)
  }

  func setPath(_ path: CurveBlurViewPath, animated: Bool = false, duration: TimeInterval = 0.3, complete: ((Bool) -> Void)? = nil) {
    
    var bezierPath: UIBezierPath
    switch path {
    case .initial:
      bezierPath = initialPath
    case .extended:
      bezierPath = extendedPath
    case .middle:
      bezierPath = initialMiddle
    case .middleUp:
      bezierPath = middleUp
    }
    maskLayer.path = bezierPath.cgPath
    animationCompleteBlock = complete
    
    guard animated else {
      return
    }
    
    let returnAnimation = CABasicAnimation(keyPath: "path")
    returnAnimation.toValue = bezierPath
    returnAnimation.duration = duration
    returnAnimation.delegate = self
    returnAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
    
    maskLayer.add(returnAnimation, forKey: nil)
  }
  
  fileprivate var extendedPath: UIBezierPath {
    let union_2Path = UIBezierPath()
    let p = bounds.width / 375.0
    
    union_2Path.move(to: CGPoint(x: -7.28 * p, y: 314.69))
    union_2Path.addCurve(to: CGPoint(x: -31.94 * p, y: 31.78), controlPoint1: CGPoint(x: -7.28 * p, y: 314.69), controlPoint2: CGPoint(x: -53.85 * p, y: 55.65))
    union_2Path.addCurve(to: CGPoint(x: 150 * p, y: 13), controlPoint1: CGPoint(x: -10.02 * p, y: 7.91), controlPoint2: CGPoint(x: 78 * p, y: -2))
    union_2Path.addCurve(to: CGPoint(x: 269 * p, y: 28), controlPoint1: CGPoint(x: 222 * p, y: 28), controlPoint2: CGPoint(x: 226 * p, y: 33))
    union_2Path.addCurve(to: CGPoint(x: 373 * p, y: 1), controlPoint1: CGPoint(x: 312 * p, y: 23), controlPoint2: CGPoint(x: 321.18 * p, y: 0.95))
    union_2Path.addCurve(to: CGPoint(x: 413.45 * p, y: 27.73), controlPoint1: CGPoint(x: 424.82 * p, y: 1.05), controlPoint2: CGPoint(x: 413.45 * p, y: 27.73))
    union_2Path.addLine(to: CGPoint(x: 387.13 * p, y: 314.7))
    union_2Path.addLine(to: CGPoint(x: -7.28 * p, y: 314.69))
    
    return union_2Path
  }
 
  fileprivate var initialPath: UIBezierPath {
    let union_2Path = UIBezierPath()
    let p = bounds.width / 375.0
    
    union_2Path.move(to: CGPoint(x: -7.28 * p, y: 314.69))
    union_2Path.addCurve(to: CGPoint(x: -31.94 * p, y: 31.78), controlPoint1: CGPoint(x: -7.28 * p, y: 314.69), controlPoint2: CGPoint(x: -53.85 * p, y: 55.65))
    union_2Path.addCurve(to: CGPoint(x: 110.44 * p, y: 16.17), controlPoint1: CGPoint(x: -10.02 * p, y: 7.91), controlPoint2: CGPoint(x: 53.88 * p, y: 3.79))
    union_2Path.addCurve(to: CGPoint(x: 224.7 * p, y: 15.23), controlPoint1: CGPoint(x: 167 * p, y: 28.55), controlPoint2: CGPoint(x: 197.35 * p, y: 19.89))
    union_2Path.addCurve(to: CGPoint(x: 318.56 * p, y: 5.46), controlPoint1: CGPoint(x: 252.04 * p, y: 10.57), controlPoint2: CGPoint(x: 266.74 * p, y: 5.41))
    union_2Path.addCurve(to: CGPoint(x: 413.45 * p, y: 27.73), controlPoint1: CGPoint(x: 370.39 * p, y: 5.52), controlPoint2: CGPoint(x: 413.45 * p, y: 27.73))
    union_2Path.addLine(to: CGPoint(x: 387.13 * p, y: 314.7))
    union_2Path.addLine(to: CGPoint(x: -7.28 * p, y: 314.69))
    
    return union_2Path
  }
  
  fileprivate var initialMiddle: UIBezierPath {
    let union_2Path = UIBezierPath()
    let p = bounds.width / 375.0
    union_2Path.move(to: CGPoint(x: -7.28 * p, y: 314.69))
    union_2Path.addCurve(to: CGPoint(x: -31.94 * p, y: 31.78), controlPoint1: CGPoint(x: -7.28 * p, y: 314.69), controlPoint2: CGPoint(x: -53.85 * p, y: 55.65))
    union_2Path.addCurve(to: CGPoint(x: 111 * p, y: 5), controlPoint1: CGPoint(x: -10.02 * p, y: 7.91), controlPoint2: CGPoint(x: 54 * p, y: -5))
    union_2Path.addCurve(to: CGPoint(x: 223 * p, y: 5), controlPoint1: CGPoint(x: 168 * p, y: 15), controlPoint2: CGPoint(x: 195.66 * p, y: 9.66))
    union_2Path.addCurve(to: CGPoint(x: 318.56 * p, y: 5.46), controlPoint1: CGPoint(x: 250.34 * p, y: 0.34), controlPoint2: CGPoint(x: 284.13 * p, y: -1.07))
    union_2Path.addCurve(to: CGPoint(x: 413 * p, y: -11), controlPoint1: CGPoint(x: 353 * p, y: 12), controlPoint2: CGPoint(x: 413 * p, y: -11))
    union_2Path.addLine(to: CGPoint(x: 387.13 * p, y: 314.7))
    union_2Path.addLine(to: CGPoint(x: -7.28 * p, y: 314.69))
    
    
//    union_2Path.move(to: CGPoint(x: -7.28, y: 314.69))
//    union_2Path.addCurve(to: CGPoint(x: -24, y: 20), controlPoint1: CGPoint(x: -7.28, y: 314.69), controlPoint2: CGPoint(x: -66, y: 38))
//    union_2Path.addCurve(to: CGPoint(x: 114, y: 28), controlPoint1: CGPoint(x: 18, y: 2), controlPoint2: CGPoint(x: 58, y: -5))
//    union_2Path.addCurve(to: CGPoint(x: 223, y: 42), controlPoint1: CGPoint(x: 170, y: 61), controlPoint2: CGPoint(x: 186, y: 58))
//    union_2Path.addCurve(to: CGPoint(x: 314, y: 42), controlPoint1: CGPoint(x: 260, y: 26), controlPoint2: CGPoint(x: 287, y: 31))
//    union_2Path.addCurve(to: CGPoint(x: 416, y: 101), controlPoint1: CGPoint(x: 341, y: 53), controlPoint2: CGPoint(x: 416, y: 101))
//    union_2Path.addLine(to: CGPoint(x: 387.13, y: 314.7))
//    union_2Path.addLine(to: CGPoint(x: -7.28, y: 314.69))
//    union_2Path.close()
    
//    union_2Path.move(to: CGPoint(x: -7.28 * p, y: 314.69))
//    union_2Path.addCurve(to: CGPoint(x: -24 * p, y: 20), controlPoint1: CGPoint(x: -7.28 * p, y: 314.69), controlPoint2: CGPoint(x: -66 * p, y: 38))
//    union_2Path.addCurve(to: CGPoint(x: 114 * p, y: 28), controlPoint1: CGPoint(x: 18 * p, y: 2), controlPoint2: CGPoint(x: 58 * p, y: -5))
//    union_2Path.addCurve(to: CGPoint(x: 224 * p, y: 20), controlPoint1: CGPoint(x: 170 * p, y: 61), controlPoint2: CGPoint(x: 191 * p, y: 35))
//    union_2Path.addCurve(to: CGPoint(x: 319 * p, y: 1), controlPoint1: CGPoint(x: 257 * p, y: 5), controlPoint2: CGPoint(x: 267.18 * p, y: 0.95))
//    union_2Path.addCurve(to: CGPoint(x: 413.45 * p, y: 27.73), controlPoint1: CGPoint(x: 370.82 * p, y: 1.05), controlPoint2: CGPoint(x: 413.45 * p, y: 27.73))
//    union_2Path.addLine(to: CGPoint(x: 387.13 * p, y: 314.7))
//    union_2Path.addLine(to: CGPoint(x: -7.28 * p, y: 314.69))
    
//    union_2Path.move(to: CGPoint(x: -7.28 * p, y: 314.69))
//    union_2Path.addCurve(to: CGPoint(x: -24 * p, y: 20), controlPoint1: CGPoint(x: -7.28 * p, y: 314.69), controlPoint2: CGPoint(x: -66 * p, y: 38))
//    union_2Path.addCurve(to: CGPoint(x: 114 * p, y: 28), controlPoint1: CGPoint(x: 18 * p, y: 2), controlPoint2: CGPoint(x: 58 * p, y: -5))
//    union_2Path.addCurve(to: CGPoint(x: 224 * p, y: 20), controlPoint1: CGPoint(x: 170 * p, y: 61), controlPoint2: CGPoint(x: 197 * p, y: 33))
//    union_2Path.addCurve(to: CGPoint(x: 318.56 * p, y: 5.46), controlPoint1: CGPoint(x: 251 * p, y: 7), controlPoint2: CGPoint(x: 266.74 * p, y: 5.41))
//    union_2Path.addCurve(to: CGPoint(x: 413.45 * p, y: 27.73), controlPoint1: CGPoint(x: 370.39 * p, y: 5.52), controlPoint2: CGPoint(x: 413.45 * p, y: 27.73))
//    union_2Path.addLine(to: CGPoint(x: 387.13 * p, y: 314.7))
//    union_2Path.addLine(to: CGPoint(x: -7.28 * p, y: 314.69))
    
    
//    union_2Path.move(to: CGPoint(x: -7.28 * p, y: 314.69))
//    union_2Path.addCurve(to: CGPoint(x: -24 * p, y: 20), controlPoint1: CGPoint(x: -7.28 * p, y: 314.69), controlPoint2: CGPoint(x: -66 * p, y: 38))
//    union_2Path.addCurve(to: CGPoint(x: 109 * p, y: 45), controlPoint1: CGPoint(x: 18 * p, y: 2), controlPoint2: CGPoint(x: 53 * p, y: 12))
//    union_2Path.addCurve(to: CGPoint(x: 222 * p, y: 45), controlPoint1: CGPoint(x: 165 * p, y: 78), controlPoint2: CGPoint(x: 195 * p, y: 58))
//    union_2Path.addCurve(to: CGPoint(x: 318.56 * p, y: 5.46), controlPoint1: CGPoint(x: 249 * p, y: 32), controlPoint2: CGPoint(x: 266.74 * p, y: 5.41))
//    union_2Path.addCurve(to: CGPoint(x: 413.45 * p, y: 27.73), controlPoint1: CGPoint(x: 370.39 * p, y: 5.52), controlPoint2: CGPoint(x: 413.45 * p, y: 27.73))
//    union_2Path.addLine(to: CGPoint(x: 387.13 * p, y: 314.7))
//    union_2Path.addLine(to: CGPoint(x: -7.28 * p, y: 314.69))

//
//    union_2Path.move(to: CGPoint(x: -7.28 * p, y: 314.69))
//    union_2Path.addCurve(to: CGPoint(x: -21 * p, y: 5), controlPoint1: CGPoint(x: -7.28 * p, y: 314.69), controlPoint2: CGPoint(x: -42.92 * p, y: 28.87))
//    union_2Path.addCurve(to: CGPoint(x: 109 * p, y: 45), controlPoint1: CGPoint(x: 0.92 * p, y: -18.87), controlPoint2: CGPoint(x: 53 * p, y: 28))
//    union_2Path.addCurve(to: CGPoint(x: 222 * p, y: 45), controlPoint1: CGPoint(x: 165 * p, y: 62), controlPoint2: CGPoint(x: 194 * p, y: 55))
//    union_2Path.addCurve(to: CGPoint(x: 318.56 * p, y: 5.46), controlPoint1: CGPoint(x: 250 * p, y: 35), controlPoint2: CGPoint(x: 266.74 * p, y: 5.41))
//    union_2Path.addCurve(to: CGPoint(x: 413.45 * p, y: 27.73), controlPoint1: CGPoint(x: 370.39 * p, y: 5.52), controlPoint2: CGPoint(x: 413.45 * p, y: 27.73))
//    union_2Path.addLine(to: CGPoint(x: 387.13 * p, y: 314.7))
//    union_2Path.addLine(to: CGPoint(x: -7.28 * p, y: 314.69))
//
    return union_2Path
  }
  
  fileprivate var middleUp: UIBezierPath {
    let union_2Path = UIBezierPath()
    let p = bounds.width / 375.0
    
//    union_2Path.move(to: CGPoint(x: -7.28 * p, y: 314.69))
//    union_2Path.addCurve(to: CGPoint(x: -22 * p, y: 87), controlPoint1: CGPoint(x: -7.28 * p, y: 314.69), controlPoint2: CGPoint(x: -41 * p, y: 116))
//    union_2Path.addCurve(to: CGPoint(x: 43 * p, y: 26), controlPoint1: CGPoint(x: -3 * p, y: 58), controlPoint2: CGPoint(x: 4 * p, y: 44))
//    union_2Path.addCurve(to: CGPoint(x: 167 * p, y: 4), controlPoint1: CGPoint(x: 82 * p, y: 8), controlPoint2: CGPoint(x: 108 * p, y: 1))
//    union_2Path.addCurve(to: CGPoint(x: 345 * p, y: 45), controlPoint1: CGPoint(x: 226 * p, y: 7), controlPoint2: CGPoint(x: 271 * p, y: 58))
//    union_2Path.addCurve(to: CGPoint(x: 408 * p, y: 87), controlPoint1: CGPoint(x: 419 * p, y: 32), controlPoint2: CGPoint(x: 408 * p, y: 87))
//    union_2Path.addLine(to: CGPoint(x: 387.13 * p, y: 314.7))
//    union_2Path.addLine(to: CGPoint(x: -7.28 * p, y: 314.69))
    union_2Path.move(to: CGPoint(x: -7.28 * p, y: 314.69))
    union_2Path.addCurve(to: CGPoint(x: -34 * p, y: 16), controlPoint1: CGPoint(x: -7.28 * p, y: 314.69), controlPoint2: CGPoint(x: -129 * p, y: 0))
    union_2Path.addCurve(to: CGPoint(x: 110.44 * p, y: 16.17), controlPoint1: CGPoint(x: 61 * p, y: 32), controlPoint2: CGPoint(x: 77.87 * p, y: 31.34))
    union_2Path.addCurve(to: CGPoint(x: 224.7 * p, y: 15.23), controlPoint1: CGPoint(x: 143 * p, y: 1), controlPoint2: CGPoint(x: 177.39 * p, y: -8.54))
    union_2Path.addCurve(to: CGPoint(x: 317 * p, y: 35), controlPoint1: CGPoint(x: 272 * p, y: 39), controlPoint2: CGPoint(x: 282 * p, y: 38))
    union_2Path.addCurve(to: CGPoint(x: 426 * p, y: -8), controlPoint1: CGPoint(x: 352 * p, y: 32), controlPoint2: CGPoint(x: 426 * p, y: -8))
    union_2Path.addLine(to: CGPoint(x: 387.13 * p, y: 314.7))
    union_2Path.addLine(to: CGPoint(x: -7.28 * p, y: 314.69))
    return union_2Path
  }
  
  
}

extension CurveBlurView: CAAnimationDelegate {
  func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
    animationCompleteBlock?(flag)
  }
}
