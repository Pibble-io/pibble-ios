//
//  CampaignEditModuleConfigurator.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 24.10.2018.
//Copyright © 2018 com.kazai. All rights reserved.
//

import UIKit

enum CampaignEditModuleConfigurator: ModuleConfigurator {
  case defaultConfig(ServiceContainerProtocol, MutablePostDraftProtocol, CampaignType)
  
  var components: ModuleComponents {
    switch self {
    case .defaultConfig(let diContainer, let postDraft, let campaignType):
      return (V: CampaignEditViewController.self,
              I: CampaignEditInteractor(postingService: diContainer.postingService,
                                        createPostService: diContainer.createPostService,
                                        postingDraft: postDraft,
                                        campaignType: campaignType),
              P: CampaignEditPresenter(),
              R: CampaignEditRouter())
    }
  }
}
