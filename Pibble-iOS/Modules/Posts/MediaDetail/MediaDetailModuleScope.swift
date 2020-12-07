//
//  MediaDetailModuleScope.swift
//  Pibble-iOS
//
//  Created by Sergey Kazakov on 06/05/2019.
//Copyright © 2019 com.kazai. All rights reserved.
//

import UIKit

enum MediaDetail {
  enum MediaContentType {
    case resized(MediaProtocol)
    case original(MediaProtocol)
    case empty
  }
  
  struct MediaDetailMediaViewModel: MediaDetailMediaViewModelProtocol {
    let contentSize: CGSize
    let urlString: String
    let thumbnailImageUrlString: String
    let contentType: ContentType
    
  }
}

extension MediaDetail {
  enum Strings {
    enum Alerts: String, LocalizedStringKeyProtocol {
      case downloading = "Downloading..."
      case cancelAction = "Cancel"
    }
    
  }
}

