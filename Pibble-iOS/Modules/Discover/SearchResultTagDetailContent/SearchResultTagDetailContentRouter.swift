//
//  SearchResultTagDetailContentRouter.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 28.12.2018.
//Copyright © 2018 com.kazai. All rights reserved.
//

import Foundation

// MARK: - SearchResultTagDetailContentRouter class
final class SearchResultTagDetailContentRouter: Router {
}

// MARK: - SearchResultTagDetailContentRouter API
extension SearchResultTagDetailContentRouter: SearchResultTagDetailContentRouterApi {
}

// MARK: - SearchResultTagDetailContent Viper Components
fileprivate extension SearchResultTagDetailContentRouter {
    var presenter: SearchResultTagDetailContentPresenterApi {
        return _presenter as! SearchResultTagDetailContentPresenterApi
    }
}
