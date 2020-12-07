//
//  SearchResultPlaceMapRouter.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 30.12.2018.
//Copyright © 2018 com.kazai. All rights reserved.
//

import Foundation

// MARK: - SearchResultPlaceMapRouter class
final class SearchResultPlaceMapRouter: Router {
}

// MARK: - SearchResultPlaceMapRouter API
extension SearchResultPlaceMapRouter: SearchResultPlaceMapRouterApi {
  func routeToFullScreenMapWith(_ place: LocationProtocol) {
    AppModules
      .Discover
      .searchResultPlaceMap(place)
      .build()?
      .router.present(withPushfrom: presenter._viewController, animated: true)
  }
}

// MARK: - SearchResultPlaceMap Viper Components
fileprivate extension SearchResultPlaceMapRouter {
    var presenter: SearchResultPlaceMapPresenterApi {
        return _presenter as! SearchResultPlaceMapPresenterApi
    }
}
