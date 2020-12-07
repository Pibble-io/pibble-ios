//
//  CampaignPickModuleConfigurator.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 29.10.2018.
//Copyright © 2018 com.kazai. All rights reserved.
//

import UIKit

enum CampaignPickModuleConfigurator: ModuleConfigurator {
  case defaultConfig(ServiceContainerProtocol, MutablePostDraftProtocol, CampaignType)
  
  var components: ModuleComponents {
    switch self {
    case .defaultConfig(let diContainer, let draft, let campaignType):
      return (V: CampaignPickViewController.self,
              I: CampaignPickInteractor(coreDataStorage: diContainer.coreDataStorageService,
                                        postingService: diContainer.postingService,
                                        createPostService: diContainer.createPostService,
                                        campaignType: campaignType,
                                        postingDraft: draft),
              P: CampaignPickPresenter(),
              R: CampaignPickRouter())
    }
  }
}
