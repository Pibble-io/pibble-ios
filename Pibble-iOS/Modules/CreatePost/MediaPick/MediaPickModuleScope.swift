//
//  MediaPickModuleScope.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 02.07.2018.
//Copyright © 2018 com.kazai. All rights reserved.
//

import UIKit
import Photos

typealias MediaPickItemCompletion = (MediaPickItemViewModelProtocol, IndexPath) -> Void
typealias MediaPickRequest = (IndexPath, ImageRequestConfig, @escaping MediaPickItemCompletion) -> Void

enum MediaPick {
  struct CropConfig {
    let center: CGPoint
    let bounds: CGRect
    let transform: CGAffineTransform
    let perCentEdgeInsets: UIEdgeInsets
  }
  
  enum PresentationStyle {
    case push
    case present
  }
  
  enum Config {
    case singleImageItem
    case multipleItems(limit: Int)
    case images(limit: Int)
    
    var pickItemsLimit: Int {
      switch self {
      case .singleImageItem:
        return 1
      case .multipleItems(let limit):
        return limit
      case .images(let limit):
        return limit
      }
    }
  }
  
  enum MediaItemType {
    case image(MediaPickRequest)
    case camera(String)
  }
  
  struct MediaItemViewModel: MediaPickItemViewModelProtocol {
    let image: UIImage
    let isSelected: Bool
    let duration: String
    let count: String
  }
  
  enum MediaPickError: PibbleErrorProtocol {
    case access
    case videoLength
    case unsupportedMediaType
    case videoWillBeTrimmed(limit: Int)
    
    var description: String {
      switch self {
      case .access:
        return Strings.Errors.access.localize()
      case .videoLength:
        return Strings.Errors.videoLength.localize()
      case .unsupportedMediaType:
        return Strings.Errors.unsupportedMediaType.localize()
     case .videoWillBeTrimmed(let limit):
        return Strings.Errors.videoWillBeTrimmed.localize(value: "\(limit)")
      }
    }
  }
}


extension MediaPick {
  enum Strings: String, LocalizedStringKeyProtocol {
    case allPhotos = "all photos"
    case videoLengthWarning = "Video length exceeds % seconds. Will be automatically trimmed for posting."
    
    case nextButtonTitle = "Next"
    case doneButtonTitle = "Done"
    
    case cancel = "Cancel"
    case confirm = "OK"
    
    enum Errors: String, LocalizedStringKeyProtocol  {
      case access = "Please, give the app access to your media library in your Settings"
      case videoLength = "Video is too long"
      case unsupportedMediaType = "Unsupported media format"
      case videoWillBeTrimmed = "Video length exceeds % seconds will be automatically trimmed for posting."
    }
    
    static func maxVideoLengthWarning(_ durationLimit: Double) -> String {
      let duration = String(format: "%.0f", durationLimit)
      return Strings.videoLengthWarning.localize(value: duration)
    }
  }
  
}
