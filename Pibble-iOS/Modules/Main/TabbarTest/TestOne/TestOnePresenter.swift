//
//  TestOnePresenter.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 28.06.2018.
//Copyright © 2018 com.kazai. All rights reserved.
//

import Foundation

// MARK: - TestOnePresenter Class
final class TestOnePresenter: Presenter {
}

// MARK: - TestOnePresenter API
extension TestOnePresenter: TestOnePresenterApi {
}

// MARK: - TestOne Viper Components
fileprivate extension TestOnePresenter {
    var viewController: TestOneViewControllerApi {
        return _viewController as! TestOneViewControllerApi
    }
    var interactor: TestOneInteractorApi {
        return _interactor as! TestOneInteractorApi
    }
    var router: TestOneRouterApi {
        return _router as! TestOneRouterApi
    }
}
