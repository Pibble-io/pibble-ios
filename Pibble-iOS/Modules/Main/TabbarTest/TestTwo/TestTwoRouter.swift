//
//  TestTwoRouter.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 28.06.2018.
//Copyright © 2018 com.kazai. All rights reserved.
//

import Foundation

// MARK: - TestTwoRouter class
final class TestTwoRouter: Router {
}

// MARK: - TestTwoRouter API
extension TestTwoRouter: TestTwoRouterApi {
}

// MARK: - TestTwo Viper Components
fileprivate extension TestTwoRouter {
    var presenter: TestTwoPresenterApi {
        return _presenter as! TestTwoPresenterApi
    }
}
