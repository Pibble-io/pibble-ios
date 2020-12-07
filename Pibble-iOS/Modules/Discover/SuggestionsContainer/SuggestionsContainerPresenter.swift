//
//   SuggestionsContainerPresenter.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 22.12.2018.
//Copyright © 2018 com.kazai. All rights reserved.
//

import Foundation

// MARK: -  SuggestionsContainerPresenter Class
final class  SuggestionsContainerPresenter: Presenter {
}

// MARK: -  SuggestionsContainerPresenter API
extension  SuggestionsContainerPresenter:  SuggestionsContainerPresenterApi {
}

// MARK: -  SuggestionsContainer Viper Components
fileprivate extension  SuggestionsContainerPresenter {
    var viewController:  SuggestionsContainerViewControllerApi {
        return _viewController as!  SuggestionsContainerViewControllerApi
    }
    var interactor:  SuggestionsContainerInteractorApi {
        return _interactor as!  SuggestionsContainerInteractorApi
    }
    var router:  SuggestionsContainerRouterApi {
        return _router as!  SuggestionsContainerRouterApi
    }
}
