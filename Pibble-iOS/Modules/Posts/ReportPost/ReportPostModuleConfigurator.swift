//
//  ReportPostModuleConfigurator.swift
//  Pibble-iOS
//
//  Created by Sergey Kazakov on 01/05/2019.
//Copyright © 2019 com.kazai. All rights reserved.
//

import UIKit

enum ReportPostModuleConfigurator: ModuleConfigurator {
  case defaultConfig(ServiceContainerProtocol, ReportPostDelegateProtocol)
  
  var components: ModuleComponents {
    switch self {
    case .defaultConfig(let diContainer, let delegate):
      return (V: ReportPostViewController.self,
              I: ReportPostInteractor(postService: diContainer.postingService),
              P: ReportPostPresenter(delegate: delegate),
              R: ReportPostRouter())
    }
  }
}
