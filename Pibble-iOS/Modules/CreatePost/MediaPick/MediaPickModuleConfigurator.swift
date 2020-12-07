//
//  MediaPickModuleConfigurator.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 02.07.2018.
//Copyright © 2018 com.kazai. All rights reserved.
//

import UIKit

enum MediaPickModuleConfigurator: ModuleConfigurator {
  case defaultConfig(ServiceContainerProtocol, MediaPickDelegateProtocol, MediaPick.Config)
  
  var components: ModuleComponents {
    switch self {
    case .defaultConfig(let diContainer, let delegate, let config):
      return (V: MediaPickViewController.self,
              I: MediaPickInteractor(mediaLibraryExportService: diContainer.mediaLibraryExportService, config: config),
              P: MediaPickPresenter(delegate: delegate),
              R: MediaPickRouter())
    }
  }
}
