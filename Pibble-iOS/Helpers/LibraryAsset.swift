//
//  LibraryAsset.swift
//  Pibble
//
//  Created by Kazakov Sergey on 10.12.2018.
//  Copyright © 2018 com.kazai. All rights reserved.
//

import UIKit
import Photos

class LibraryAsset {
  var underlyingAsset: PHAsset
  var crop: UIEdgeInsets
  var shouldUseAsDigitalGood: Bool
  
  init(asset: PHAsset, crop: UIEdgeInsets = UIEdgeInsets.zero, shouldUserOriginalSize: Bool = false) {
    self.underlyingAsset = asset
    self.crop = crop
    self.shouldUseAsDigitalGood = shouldUserOriginalSize
  }
}

class ImageAsset {
  var underlyingAsset: UIImage
  var shouldUseAsDigitalGood: Bool
  
  init(asset: UIImage, isOriginalSize: Bool = false) {
    self.underlyingAsset = asset
    self.shouldUseAsDigitalGood = isOriginalSize
  }
}
