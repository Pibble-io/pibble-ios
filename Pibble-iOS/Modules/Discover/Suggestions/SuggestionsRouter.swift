//
//  SuggestionsRouter.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 22.12.2018.
//Copyright © 2018 com.kazai. All rights reserved.
//

import Foundation

// MARK: - SuggestionsRouter class
final class SuggestionsRouter: Router {
}

// MARK: - SuggestionsRouter API
extension SuggestionsRouter: SuggestionsRouterApi {
}

// MARK: - Suggestions Viper Components
fileprivate extension SuggestionsRouter {
    var presenter: SuggestionsPresenterApi {
        return _presenter as! SuggestionsPresenterApi
    }
}
