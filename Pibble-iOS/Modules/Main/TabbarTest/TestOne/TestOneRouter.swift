//
//  TestOneRouter.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 28.06.2018.
//Copyright © 2018 com.kazai. All rights reserved.
//

import Foundation

// MARK: - TestOneRouter class
final class TestOneRouter: Router {
}

// MARK: - TestOneRouter API
extension TestOneRouter: TestOneRouterApi {
}

// MARK: - TestOne Viper Components
fileprivate extension TestOneRouter {
    var presenter: TestOnePresenterApi {
        return _presenter as! TestOnePresenterApi
    }
}
