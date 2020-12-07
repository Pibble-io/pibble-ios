//
//  UIImageQRCodeExtension.swift
//  Pibble
//
//  Created by Kazakov Sergey on 30.08.2018.
//  Copyright © 2018 com.kazai. All rights reserved.
//

import Foundation

import UIKit
import CoreImage

extension UIImage {
  static func createQRCodeImageFrom(_ text: String, size: CGSize) -> UIImage? {
    guard let ciImage = createQRCIImageFromString(text) else {
      return nil
    }
    
    let scaleX = size.width / ciImage.extent.size.width
    let scaleY = size.height / ciImage.extent.size.height
    
    let transformedImage = ciImage.transformed(by: CGAffineTransform(scaleX: scaleX, y: scaleY))
    return UIImage(ciImage: transformedImage)
  }
 
  fileprivate static func createQRCIImageFromString(_ str: String) -> CIImage? {
    let stringData = str.data(using: String.Encoding.isoLatin1, allowLossyConversion: false)
    
    let filter = CIFilter(name: "CIQRCodeGenerator")
    filter?.setValue(stringData, forKey: "inputMessage")
    filter?.setValue("H", forKey: "inputCorrectionLevel")
    
    return filter?.outputImage
  }
}


