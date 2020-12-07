//
//  TagPickRouter.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 20.07.2018.
//Copyright © 2018 com.kazai. All rights reserved.
//

import Foundation

// MARK: - TagPickRouter class
final class TagPickRouter: Router {
}

// MARK: - TagPickRouter API
extension TagPickRouter: TagPickRouterApi {
}

// MARK: - TagPick Viper Components
fileprivate extension TagPickRouter {
    var presenter: TagPickPresenterApi {
        return _presenter as! TagPickPresenterApi
    }
}
