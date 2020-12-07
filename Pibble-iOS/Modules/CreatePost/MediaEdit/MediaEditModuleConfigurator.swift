//
//  MediaEditModuleConfigurator.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 12.07.2018.
//Copyright © 2018 com.kazai. All rights reserved.
//

import UIKit

enum MediaEditModuleConfigurator: ModuleConfigurator {
  case defaultConfig(MediaType, MediaEditDelegateProtocol)
  
  var components: ModuleComponents {
    switch self {
    case .defaultConfig(let inputAsset, let mediaEditDelegate):
      return (V: MediaEditViewController.self,
              I: MediaEditInteractor(inputAsset: inputAsset),
              P: MediaEditPresenter(delegate: mediaEditDelegate),
              R: MediaEditRouter())
    }
  }
}
