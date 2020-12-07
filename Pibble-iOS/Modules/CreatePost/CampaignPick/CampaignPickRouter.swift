//
//  CampaignPickRouter.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 29.10.2018.
//Copyright © 2018 com.kazai. All rights reserved.
//

import Foundation

// MARK: - CampaignPickRouter class
final class CampaignPickRouter: Router {
}

// MARK: - CampaignPickRouter API
extension CampaignPickRouter: CampaignPickRouterApi {
}

// MARK: - CampaignPick Viper Components
fileprivate extension CampaignPickRouter {
    var presenter: CampaignPickPresenterApi {
        return _presenter as! CampaignPickPresenterApi
    }
}
