//
//  UIViewSnapshotExtensions.swift
//  Pibble
//
//  Created by Sergey Kazakov on 08/02/2019.
//  Copyright © 2019 com.kazai. All rights reserved.
//

import UIKit

extension UIView {
  func takeSnapshot() -> UIImage? {
    UIGraphicsBeginImageContextWithOptions(bounds.size, false, 0.0)
    drawHierarchy(in: bounds, afterScreenUpdates: false)
    
    let image = UIGraphicsGetImageFromCurrentImageContext()
    
    UIGraphicsEndImageContext()
    return image
  }
}

