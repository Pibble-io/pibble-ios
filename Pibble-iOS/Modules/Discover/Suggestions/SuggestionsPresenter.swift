//
//  SuggestionsPresenter.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 22.12.2018.
//Copyright © 2018 com.kazai. All rights reserved.
//

import Foundation

// MARK: - SuggestionsPresenter Class
final class SuggestionsPresenter: Presenter {
}

// MARK: - SuggestionsPresenter API
extension SuggestionsPresenter: SuggestionsPresenterApi {
}

// MARK: - Suggestions Viper Components
fileprivate extension SuggestionsPresenter {
    var viewController: SuggestionsViewControllerApi {
        return _viewController as! SuggestionsViewControllerApi
    }
    var interactor: SuggestionsInteractorApi {
        return _interactor as! SuggestionsInteractorApi
    }
    var router: SuggestionsRouterApi {
        return _router as! SuggestionsRouterApi
    }
}
