//
//  SearchResultPlaceMapModuleConfigurator.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 30.12.2018.
//Copyright © 2018 com.kazai. All rights reserved.
//

import UIKit

enum SearchResultPlaceMapModuleConfigurator: ModuleConfigurator {
  case defaultConfig(LocationProtocol)
  case searchResultPlaceMapContent(LocationProtocol)
  
  var components: ModuleComponents {
    switch self {
    case .defaultConfig(let place):
      return (V: SearchResultPlaceMapViewController.self,
              I: SearchResultPlaceMapInteractor(place: place),
              P: SearchResultPlaceMapPresenter(),
              R: SearchResultPlaceMapRouter())
    case .searchResultPlaceMapContent(let place):
      return (V: SearchResultPlaceMapContentViewController.self,
              I: SearchResultPlaceMapInteractor(place: place),
              P: SearchResultPlaceMapPresenter(),
              R: SearchResultPlaceMapRouter())
    }
  }
}
