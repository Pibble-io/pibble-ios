//
//  SearchResultPlaceMapInteractor.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 30.12.2018.
//Copyright © 2018 com.kazai. All rights reserved.
//

import Foundation 

// MARK: - SearchResultPlaceMapInteractor Class
final class SearchResultPlaceMapInteractor: Interactor {
  let place: LocationProtocol
  
  init(place: LocationProtocol) {
    self.place = place
  }
}

// MARK: - SearchResultPlaceMapInteractor API
extension SearchResultPlaceMapInteractor: SearchResultPlaceMapInteractorApi {
  func initialFetchData() {
    presenter.presentPlace(place)
  }
  
}

// MARK: - Interactor Viper Components Api
private extension SearchResultPlaceMapInteractor {
    var presenter: SearchResultPlaceMapPresenterApi {
        return _presenter as! SearchResultPlaceMapPresenterApi
    }
}
