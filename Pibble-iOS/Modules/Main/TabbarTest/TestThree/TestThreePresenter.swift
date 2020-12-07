//
//  TestThreePresenter.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 28.06.2018.
//Copyright © 2018 com.kazai. All rights reserved.
//

import Foundation

// MARK: - TestThreePresenter Class
final class TestThreePresenter: Presenter {
}

// MARK: - TestThreePresenter API
extension TestThreePresenter: TestThreePresenterApi {
}

// MARK: - TestThree Viper Components
fileprivate extension TestThreePresenter {
    var viewController: TestThreeViewControllerApi {
        return _viewController as! TestThreeViewControllerApi
    }
    var interactor: TestThreeInteractorApi {
        return _interactor as! TestThreeInteractorApi
    }
    var router: TestThreeRouterApi {
        return _router as! TestThreeRouterApi
    }
}
