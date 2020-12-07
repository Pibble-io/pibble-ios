//
//  MediaAlbumPickModuleConfigurator.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 12.12.2018.
//Copyright © 2018 com.kazai. All rights reserved.
//

import UIKit

enum MediaAlbumPickModuleConfigurator: ModuleConfigurator {
  case defaultConfig(MediaAlbumPickDelegateProtocol)
  
  var components: ModuleComponents {
    switch self {
    case .defaultConfig(let delegate):
      return (V: MediaAlbumPickViewController.self,
              I: MediaAlbumPickInteractor(),
              P: MediaAlbumPickPresenter(delegate: delegate),
              R: MediaAlbumPickRouter())
    }
  }
}
