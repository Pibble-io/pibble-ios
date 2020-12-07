//
//  UpVoteRouter.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 05.09.2018.
//Copyright © 2018 com.kazai. All rights reserved.
//

import Foundation

// MARK: - UpVoteRouter class
final class UpVoteRouter: Router {
}

// MARK: - UpVoteRouter API
extension UpVoteRouter: UpVoteRouterApi {
}

// MARK: - UpVote Viper Components
fileprivate extension UpVoteRouter {
    var presenter: UpVotePresenterApi {
        return _presenter as! UpVotePresenterApi
    }
}
