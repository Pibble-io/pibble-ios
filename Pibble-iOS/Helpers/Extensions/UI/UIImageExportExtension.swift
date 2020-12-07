//
//  UIImageExportExtension.swift
//  Pibble
//
//  Created by Kazakov Sergey on 19.07.2018.
//  Copyright © 2018 com.kazai. All rights reserved.
//

import UIKit


extension UIImage {
  func saveAsPNG(_ name: String) throws -> URL {
    let assetLocalPath = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(name)
    try self.pngData()?.write(to: assetLocalPath)
    return assetLocalPath
  }
  
  fileprivate func resized(toMaxSize maxSize: CGFloat) -> UIImage? {
    var newWidth: CGFloat = size.width
    var newHeight: CGFloat = size.height
    
    let width: CGFloat = size.width
    let height: CGFloat = size.height
    
    if width > maxSize || height > maxSize {
      if width > height {
        newWidth = maxSize;
        newHeight = (height * maxSize) / width
      } else {
        newHeight = maxSize;
        newWidth = (width * maxSize) / height;
      }
    }
    
    let canvasSize = CGSize(width: ceil(newWidth), height: CGFloat(ceil(newHeight)))
    UIGraphicsBeginImageContextWithOptions(canvasSize, false, scale)
    defer { UIGraphicsEndImageContext() }
    draw(in: CGRect(origin: .zero, size: canvasSize))
    return UIGraphicsGetImageFromCurrentImageContext()
  }
}


