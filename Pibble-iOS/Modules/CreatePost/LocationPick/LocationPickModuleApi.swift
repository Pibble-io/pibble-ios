//
//  LocationPickModuleApi.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 23.07.2018.
//Copyright © 2018 com.kazai. All rights reserved.
//

import Foundation

//MARK: - LocationPickRouter API
protocol LocationPickRouterApi: RouterProtocol {
}

//MARK: - LocationPickView API
protocol LocationPickViewControllerApi: ViewControllerProtocol {
  func reloadLocationsCollection()
}

//MARK: - LocationPickPresenter API
protocol LocationPickPresenterApi: PresenterProtocol {
  func handleDoneAction()
  func handleHideAction()
  
  func handleInputTextChange(_ text: String)
  
  func numberOfSections() -> Int
  func numberOfItemsInSection(_ section: Int) -> Int
  func itemViewModelFor(_ indexPath: IndexPath) -> LocationPick.ItemType
  func handleSelectionAt(_ indexPath: IndexPath)
  
  func presentLocationsCollection()
  func presentLocationInformation(_ location: SearchLocationProtocol)
}

//MARK: - LocationPickInteractor API
protocol LocationPickInteractorApi: InteractorProtocol {
  func searchLocationsFor(_ string: String)
  
  func numberOfItems() -> Int
  func itemFor(_ item: Int) -> SearchAutocompleteLocationProtocol
  func searchLocationInformationFor(_ item: Int)
}

protocol LocationItemViewModelProtocol {
  var title: String { get }
  var locationDescription: String { get }
  var imageUrlString: String? { get }
  var presentationStyle: LocationPick.ItemPresentationStyle { get } 
}

protocol LocationPickDelegateProtocol: class {
  func didSelectLocation(_ location: SearchLocationProtocol)
}
