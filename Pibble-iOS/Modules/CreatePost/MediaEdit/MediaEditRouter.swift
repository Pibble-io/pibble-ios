//
//  MediaEditRouter.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 12.07.2018.
//Copyright © 2018 com.kazai. All rights reserved.
//

import Foundation

// MARK: - MediaEditRouter class
final class MediaEditRouter: Router {
}

// MARK: - MediaEditRouter API
extension MediaEditRouter: MediaEditRouterApi {
}

// MARK: - MediaEdit Viper Components
fileprivate extension MediaEditRouter {
    var presenter: MediaEditPresenterApi {
        return _presenter as! MediaEditPresenterApi
    }
}
