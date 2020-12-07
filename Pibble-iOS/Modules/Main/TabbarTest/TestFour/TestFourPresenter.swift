//
//  TestFourPresenter.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 28.06.2018.
//Copyright © 2018 com.kazai. All rights reserved.
//

import Foundation

// MARK: - TestFourPresenter Class
final class TestFourPresenter: Presenter {
}

// MARK: - TestFourPresenter API
extension TestFourPresenter: TestFourPresenterApi {
}

// MARK: - TestFour Viper Components
fileprivate extension TestFourPresenter {
    var viewController: TestFourViewControllerApi {
        return _viewController as! TestFourViewControllerApi
    }
    var interactor: TestFourInteractorApi {
        return _interactor as! TestFourInteractorApi
    }
    var router: TestFourRouterApi {
        return _router as! TestFourRouterApi
    }
}
