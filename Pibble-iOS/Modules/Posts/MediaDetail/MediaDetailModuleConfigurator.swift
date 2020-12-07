//
//  MediaDetailModuleConfigurator.swift
//  Pibble-iOS
//
//  Created by Sergey Kazakov on 06/05/2019.
//Copyright © 2019 com.kazai. All rights reserved.
//

import UIKit

enum MediaDetailModuleConfigurator: ModuleConfigurator {
  case defaultConfig(ServiceContainerProtocol, PostingProtocol, MediaProtocol)
  
  var components: ModuleComponents {
    switch self {
    case .defaultConfig(let diContainer, let post, let media):
      return (V: MediaDetailViewController.self,
              I: MediaDetailInteractor(post: post, media:media, mediaDownloadService: diContainer.mediaDownloadService),
              P: MediaDetailPresenter(),
              R: MediaDetailRouter())
    }
  }
}
