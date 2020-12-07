//
//  ExportedLibraryAsset.swift
//  Pibble
//
//  Created by Kazakov Sergey on 11.12.2018.
//  Copyright © 2018 com.kazai. All rights reserved.
//

import UIKit

enum ExportedLibraryAsset: ResizableVideoFile {
  case photo(URL, original: URL?)
  case rawVideo(URL, requiredCrop: UIEdgeInsets)
 
  var fileURL: URL {
    switch self {
    case .photo(let url, _):
      return url
    case .rawVideo(let url, _):
      return url
    }
  }
  
  var additionalFileUrl: URL? {
    switch self {
    case .photo(_, let original):
      return original
    case .rawVideo:
      return nil
    }
  }
  
  var crop: UIEdgeInsets {
    switch self {
    case .photo(_):
      return UIEdgeInsets.zero
    case .rawVideo(_, let crop):
      return crop
    }
  }
  
  init(rawVideoURL: URL) {
    self = .rawVideo(rawVideoURL, requiredCrop: UIEdgeInsets.zero)
  }
  
  init(rawVideoURL: URL, withCropRequired: UIEdgeInsets) {
    self = .rawVideo(rawVideoURL, requiredCrop: withCropRequired)
  }
  
  init(exportedPhotoURL: URL) {
    self = .photo(exportedPhotoURL, original: nil)
  }
  
  init(exportedPhotoURL: URL, originalPhoto: URL) {
    self = .photo(exportedPhotoURL, original: originalPhoto)
  }
}
