//
//  SearchResultPlaceMapPresenter.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 30.12.2018.
//Copyright © 2018 com.kazai. All rights reserved.
//

import Foundation
import MapKit

// MARK: - SearchResultPlaceMapPresenter Class
final class SearchResultPlaceMapPresenter: Presenter {
  fileprivate var viewModelsForAnnotation: [String: SearchResultPlaceMapItemViewModelProtocol] = [:]
  
  override func viewDidLoad() {
    super.viewDidLoad()
    viewController.setNavBarTitle("")
  }
  
  override func viewWillAppear() {
    super.viewDidAppear()
    interactor.initialFetchData()
  }
}

// MARK: - SearchResultPlaceMapPresenter API
extension SearchResultPlaceMapPresenter: SearchResultPlaceMapPresenterApi {
  func handleHideAction() {
    router.dismiss()
  }
  
  func handleMapSelecion() {
    router.routeToFullScreenMapWith(interactor.place)
  }
  
  func viewModelItemFor(_ annotation: MKAnnotation) -> SearchResultPlaceMapItemViewModelProtocol? {
    return viewModelsForAnnotation[annotation.key]
  }
  
  func presentPlace(_ place: LocationProtocol) {
    viewModelsForAnnotation = [:]
    let viewModel = SearchResultPlaceMap.ItemViewModel(place: place)
    
    if let annotation = viewModel.mapAnnotation {
      viewModelsForAnnotation[annotation.key] = viewModel
    }
    
    viewController.setNavBarTitle(viewModel.title)
    viewController.showMapItem(viewModel)
  }
}

// MARK: - SearchResultPlaceMap Viper Components
fileprivate extension SearchResultPlaceMapPresenter {
    var viewController: SearchResultPlaceMapViewControllerApi {
        return _viewController as! SearchResultPlaceMapViewControllerApi
    }
    var interactor: SearchResultPlaceMapInteractorApi {
        return _interactor as! SearchResultPlaceMapInteractorApi
    }
    var router: SearchResultPlaceMapRouterApi {
        return _router as! SearchResultPlaceMapRouterApi
    }
}


fileprivate extension MKAnnotation {
  var key: String {
    let annotationTitle: String? = title ?? ""
    return "\(coordinate.latitude)_\(coordinate.longitude)_\(annotationTitle ?? "")"
  }
}
