//
//  DonateRouter.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 30.10.2018.
//Copyright © 2018 com.kazai. All rights reserved.
//

import Foundation

// MARK: - DonateRouter class
final class DonateRouter: Router {
}

// MARK: - DonateRouter API
extension DonateRouter: DonateRouterApi {
}

// MARK: - Donate Viper Components
fileprivate extension DonateRouter {
    var presenter: DonatePresenterApi {
        return _presenter as! DonatePresenterApi
    }
}
