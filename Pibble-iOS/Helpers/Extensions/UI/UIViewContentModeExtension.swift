//
//  UIViewContentModeExtension.swift
//  Pibble
//
//  Created by Kazakov Sergey on 13.07.2018.
//  Copyright © 2018 com.kazai. All rights reserved.
//

import UIKit
import Photos

extension UIView.ContentMode {
  var photosContentMode: PHImageContentMode {
    switch self {
    case .scaleToFill:
      return .aspectFill
    case .scaleAspectFit:
      return .aspectFit
    case .scaleAspectFill:
      return .aspectFill
    default:
      return .aspectFill
    }
  }
}
