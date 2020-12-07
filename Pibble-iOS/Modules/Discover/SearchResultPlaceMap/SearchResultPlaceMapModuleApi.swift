//
//  SearchResultPlaceMapModuleApi.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 30.12.2018.
//Copyright © 2018 com.kazai. All rights reserved.
//
import UIKit
import MapKit

//MARK: - SearchResultPlaceMapRouter API
protocol SearchResultPlaceMapRouterApi: RouterProtocol {
  func routeToFullScreenMapWith(_ place: LocationProtocol)
}

//MARK: - SearchResultPlaceMapView API
protocol SearchResultPlaceMapViewControllerApi: ViewControllerProtocol {
  func showMapItem(_ mapItem: SearchResultPlaceMapItemViewModelProtocol)
  func setNavBarTitle(_ text: String)
}

//MARK: - SearchResultPlaceMapPresenter API
protocol SearchResultPlaceMapPresenterApi: PresenterProtocol {
  func viewModelItemFor(_ annotation: MKAnnotation) -> SearchResultPlaceMapItemViewModelProtocol?
  func handleMapSelecion()
  func handleHideAction()
  
  func presentPlace(_ place: LocationProtocol)
}

//MARK: - SearchResultPlaceMapInteractor API
protocol SearchResultPlaceMapInteractorApi: InteractorProtocol {
  func initialFetchData()
  var place: LocationProtocol { get }
}

protocol SearchResultPlaceMapItemViewModelProtocol {
  var mapAnnotation: MKAnnotation? { get }
  var image: UIImage? { get }
  var title: String { get }
}
