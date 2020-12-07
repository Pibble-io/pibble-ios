//
//  CampaignEditRouter.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 24.10.2018.
//Copyright © 2018 com.kazai. All rights reserved.
//

import Foundation

// MARK: - CampaignEditRouter class
final class CampaignEditRouter: Router {
  fileprivate var mediaPickModule: Module?
}

// MARK: - CampaignEditRouter API
extension CampaignEditRouter: CampaignEditRouterApi {
  func routeToMediaPickWith(_ delegate: MediaPickDelegateProtocol) {
    mediaPickModule =
    AppModules
      .CreatePost
      .mediaPick(delegate, .singleImageItem)
      .build()
      
      
    mediaPickModule?.router.present(from: presenter._viewController)
  }
  
  func dismissMediaPick() {
    mediaPickModule?.router.dismiss()
  }
}

// MARK: - CampaignEdit Viper Components
fileprivate extension CampaignEditRouter {
    var presenter: CampaignEditPresenterApi {
        return _presenter as! CampaignEditPresenterApi
    }
}
