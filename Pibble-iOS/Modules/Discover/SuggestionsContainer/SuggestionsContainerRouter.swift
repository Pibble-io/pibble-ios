//
//   SuggestionsContainerRouter.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 22.12.2018.
//Copyright © 2018 com.kazai. All rights reserved.
//

import Foundation

// MARK: -  SuggestionsContainerRouter class
final class  SuggestionsContainerRouter: Router {
}

// MARK: -  SuggestionsContainerRouter API
extension  SuggestionsContainerRouter:  SuggestionsContainerRouterApi {
}

// MARK: -  SuggestionsContainer Viper Components
fileprivate extension  SuggestionsContainerRouter {
    var presenter:  SuggestionsContainerPresenterApi {
        return _presenter as!  SuggestionsContainerPresenterApi
    }
}
