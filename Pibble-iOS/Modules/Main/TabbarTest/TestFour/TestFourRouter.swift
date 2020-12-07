//
//  TestFourRouter.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 28.06.2018.
//Copyright © 2018 com.kazai. All rights reserved.
//

import Foundation

// MARK: - TestFourRouter class
final class TestFourRouter: Router {
}

// MARK: - TestFourRouter API
extension TestFourRouter: TestFourRouterApi {
}

// MARK: - TestFour Viper Components
fileprivate extension TestFourRouter {
    var presenter: TestFourPresenterApi {
        return _presenter as! TestFourPresenterApi
    }
}
