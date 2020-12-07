//
//  DescriptionPickRouter.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 24.07.2018.
//Copyright © 2018 com.kazai. All rights reserved.
//

import Foundation

// MARK: - DescriptionPickRouter class
final class DescriptionPickRouter: Router {
}

// MARK: - DescriptionPickRouter API
extension DescriptionPickRouter: DescriptionPickRouterApi {
}

// MARK: - DescriptionPick Viper Components
fileprivate extension DescriptionPickRouter {
    var presenter: DescriptionPickPresenterApi {
        return _presenter as! DescriptionPickPresenterApi
    }
}
