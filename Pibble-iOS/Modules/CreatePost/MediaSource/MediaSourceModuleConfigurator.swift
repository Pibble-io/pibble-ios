//
//  MediaSourceModuleConfigurator.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 09.07.2018.
//Copyright © 2018 com.kazai. All rights reserved.
//

import UIKit

enum MediaSourceModuleConfigurator: ModuleConfigurator {
  case defaultConfig(MutablePostDraftProtocol)
  
  var components: ModuleComponents {
    switch self {
    case .defaultConfig(let postDraft):
      return (V: MediaSourceViewController.self,
              I: MediaSourceInteractor(),
              P: MediaSourcePresenter(postDraft: postDraft),
              R: MediaSourceRouter(postDraft: postDraft))
    }
  }
}
