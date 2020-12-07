//
//  ExternalLinkModuleConfigurator.swift
//  Pibble-iOS
//
//  Created by Sergey Kazakov on 20/05/2019.
//Copyright © 2019 com.kazai. All rights reserved.
//

import UIKit

enum ExternalLinkModuleConfigurator: ModuleConfigurator {
  case defaultConfig(URL, String)
  case modalConfig(URL, String)
  
  var components: ModuleComponents {
    switch self {
    case .defaultConfig(let url, let title):
      return (V: ExternalLinkViewController.self,
              I: ExternalLinkInteractor(),
              P: ExternalLinkPresenter(url: url, title: title),
              R: ExternalLinkRouter())
    case .modalConfig(let url, let title):
      return (V: ExternalLinkModalViewController.self,
              I: ExternalLinkInteractor(),
              P: ExternalLinkPresenter(url: url, title: title),
              R: ExternalLinkRouter())
    }
  }
}
