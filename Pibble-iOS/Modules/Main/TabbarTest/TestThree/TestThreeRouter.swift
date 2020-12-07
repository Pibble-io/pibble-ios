//
//  TestThreeRouter.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 28.06.2018.
//Copyright © 2018 com.kazai. All rights reserved.
//

import Foundation

// MARK: - TestThreeRouter class
final class TestThreeRouter: Router {
}

// MARK: - TestThreeRouter API
extension TestThreeRouter: TestThreeRouterApi {
}

// MARK: - TestThree Viper Components
fileprivate extension TestThreeRouter {
    var presenter: TestThreePresenterApi {
        return _presenter as! TestThreePresenterApi
    }
}
