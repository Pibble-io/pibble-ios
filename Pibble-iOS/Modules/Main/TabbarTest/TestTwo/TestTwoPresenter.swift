//
//  TestTwoPresenter.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 28.06.2018.
//Copyright © 2018 com.kazai. All rights reserved.
//

import Foundation

// MARK: - TestTwoPresenter Class
final class TestTwoPresenter: Presenter {
}

// MARK: - TestTwoPresenter API
extension TestTwoPresenter: TestTwoPresenterApi {
}

// MARK: - TestTwo Viper Components
fileprivate extension TestTwoPresenter {
    var viewController: TestTwoViewControllerApi {
        return _viewController as! TestTwoViewControllerApi
    }
    var interactor: TestTwoInteractorApi {
        return _interactor as! TestTwoInteractorApi
    }
    var router: TestTwoRouterApi {
        return _router as! TestTwoRouterApi
    }
}
