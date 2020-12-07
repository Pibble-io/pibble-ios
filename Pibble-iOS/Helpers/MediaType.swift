//
//  InputMediaType.swift
//  Pibble
//
//  Created by Kazakov Sergey on 13.07.2018.
//  Copyright © 2018 com.kazai. All rights reserved.
//

import Photos
import AVFoundation
import UIKit

enum MediaType {
  case video(URL)
  case image(ImageAsset)
  case libraryMediaItem(LibraryAsset)
  
  var shouldUseAsDigitalGood: Bool {
    get {
      switch self {
      case .video(_):
        return false
      case .image(let imageAsset):
        return imageAsset.shouldUseAsDigitalGood
      case .libraryMediaItem(let libraryAsset):
        return libraryAsset.shouldUseAsDigitalGood
      }
    }
    
    set {
      switch self {
      case .video(_):
        break
      case .image(let imageAsset):
        imageAsset.shouldUseAsDigitalGood = newValue
      case .libraryMediaItem(let libraryAsset):
        libraryAsset.shouldUseAsDigitalGood = newValue
      }
    }
  }
}
