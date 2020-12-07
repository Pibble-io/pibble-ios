//
//  CircleProgressBarView.swift
//  Pibble
//
//  Created by Kazakov Sergey on 06.07.2018.
//  Copyright © 2018 com.kazai. All rights reserved.
//

import UIKit

class CircleProgressBarView: UIView {
  fileprivate var startAngle = CGFloat.pi * 1.5
  fileprivate var endAngle = (CGFloat.pi * 1.5) + (CGFloat.pi * 2.0)
  var percent: CGFloat = 0.0
  
  var progressBarWidth: CGFloat = 1.0
  var progressBarColor = UIColor.black
  var progressBarBackgroundColor = UIColor.lightGray
  
  override func draw(_ rect: CGRect) {
    let bezierPath = UIBezierPath()
    let centerPoint = CGPoint(x: bounds.midX, y: bounds.midY)
    let radius = bounds.width * 0.5 - progressBarWidth
    let currentEndAngle = (endAngle - startAngle) * (percent / 100.0) + startAngle
    bezierPath.addArc(withCenter: centerPoint,
                      radius: radius,
                      startAngle: startAngle,
                      endAngle: currentEndAngle,
                      clockwise: true)
    
    bezierPath.lineWidth = progressBarWidth
    progressBarColor.setStroke()
    bezierPath.stroke()
    
    let bezierPathBackground = UIBezierPath()
    bezierPathBackground.addArc(withCenter: centerPoint,
                      radius: radius,
                      startAngle: currentEndAngle,
                      endAngle: endAngle,
                      clockwise: true)
    bezierPathBackground.lineWidth = progressBarWidth
    progressBarBackgroundColor.setStroke()
    bezierPathBackground.stroke()
  }

  
//
//  NSString* textContent = [NSString stringWithFormat:@"%d", self.percent];
//
//  UIBezierPath* bezierPath = [UIBezierPath bezierPath];
//
//  // Create our arc, with the correct angles
//  [bezierPath addArcWithCenter:CGPointMake(rect.size.width / 2, rect.size.height / 2)
//  radius:130
//  startAngle:startAngle
//  endAngle:(endAngle - startAngle) * (_percent / 100.0) + startAngle
//  clockwise:YES];
//
//  // Set the display for the path, and stroke it
//  bezierPath.lineWidth = 20;
//  [[UIColor redColor] setStroke];
//  [bezierPath stroke];
//
//  // Text Drawing
//  CGRect textRect = CGRectMake((rect.size.width / 2.0) - 71/2.0, (rect.size.height / 2.0) - 45/2.0, 71, 45);
//  [[UIColor blackColor] setFill];
//  [textContent drawInRect: textRect withFont: [UIFont fontWithName: @"Helvetica-Bold" size: 42.5] lineBreakMode: NSLineBreakByWordWrapping alignment: NSTextAlignmentCenter];

}
