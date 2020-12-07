//
//  MediaEditModuleScope.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 12.07.2018.
//Copyright © 2018 com.kazai. All rights reserved.
//

import UIKit
import Photos
import AVFoundation

enum MediaEdit {
  enum MediaFetchRequest {
    case video
    case image
    case libraryMediaItem(ImageRequestConfig)
  }
  
  enum PresentableMedia {
    case video(AVPlayerLayer)
    case image(UIImage)
  }
  
  enum MediaEditError: PibbleErrorProtocol {
    case couldNotLoadMedia
    
    var description: String {
      switch self {
      case .couldNotLoadMedia:
        return Strings.Errors.couldNotLoadMedia.localize()
      }
    }
  }
  
  enum EditMode {
    case filter
    case crop
    case rotate
    case sticker
    case drawing
    case text
  }
}

extension MediaEdit {
  enum Strings {
    enum Errors: String, LocalizedStringKeyProtocol {
      case couldNotLoadMedia = "Could not load media"
    }
  }
}
