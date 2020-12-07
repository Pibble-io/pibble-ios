//
//  PostHelpRewardPickRouter.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 05.09.2018.
//Copyright © 2018 com.kazai. All rights reserved.
//

import Foundation

// MARK: - PostHelpRewardPickRouter class
final class PostHelpRewardPickRouter: Router {
}

// MARK: - PostHelpRewardPickRouter API
extension PostHelpRewardPickRouter: PostHelpRewardPickRouterApi {
}

// MARK: - PostHelpRewardPick Viper Components
fileprivate extension PostHelpRewardPickRouter {
    var presenter: PostHelpRewardPickPresenterApi {
        return _presenter as! PostHelpRewardPickPresenterApi
    }
}
