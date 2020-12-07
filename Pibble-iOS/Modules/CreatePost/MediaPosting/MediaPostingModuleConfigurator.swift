//
//  MediaPostingModuleConfigurator.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 13.07.2018.
//Copyright © 2018 com.kazai. All rights reserved.
//

import UIKit

enum MediaPostingModuleConfigurator: ModuleConfigurator {
  case defaultConfig(ServiceContainerProtocol, MutablePostDraftProtocol)
  
  var components: ModuleComponents {
    switch self {
    case .defaultConfig(let serviceContainer, let postingDraft):
      return (V: MediaPostingViewController.self,
              I: MediaPostingInteractor(mediaLibraryExportService: serviceContainer.mediaLibraryExportService,
                                        createPostService: serviceContainer.createPostService,
                                        accountService: serviceContainer.accountProfileService,
                                        postingDraft: postingDraft),
              P: MediaPostingPresenter(),
              R: MediaPostingRouter())
    }
  }
}
