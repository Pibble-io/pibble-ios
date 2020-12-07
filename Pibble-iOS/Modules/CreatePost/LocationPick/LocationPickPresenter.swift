//
//  LocationPickPresenter.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 23.07.2018.
//Copyright © 2018 com.kazai. All rights reserved.
//

import Foundation

fileprivate enum Sections {
  //  case map
  case locations
}

fileprivate struct MapItem {
  let imageUrlString: String
}

// MARK: - LocationPickPresenter Class
final class LocationPickPresenter: Presenter {
  fileprivate let sections: [Sections] = [.locations]
  fileprivate weak var delegate: LocationPickDelegateProtocol?
  
  init(delegate: LocationPickDelegateProtocol) {
    self.delegate = delegate
  }
}

// MARK: - LocationPickPresenter API
extension LocationPickPresenter: LocationPickPresenterApi {
  func presentLocationInformation(_ location: SearchLocationProtocol) {
    delegate?.didSelectLocation(location)
    router.dismiss()
  }
  
  func handleSelectionAt(_ indexPath: IndexPath) {
    let sectionType = sections[indexPath.section]
    switch sectionType {
    case .locations:
      interactor.searchLocationInformationFor(indexPath.item)
    }
    
  }
  
  func presentLocationsCollection() {
    viewController.reloadLocationsCollection()
  }
  
  func numberOfSections() -> Int {
    return sections.count
  }
  
  func numberOfItemsInSection(_ section: Int) -> Int {
    let sectionType = sections[section]
    switch sectionType {
    case .locations:
      return interactor.numberOfItems()
    }
  }
  
  func itemViewModelFor(_ indexPath: IndexPath) -> LocationPick.ItemType {
    let sectionType = sections[indexPath.section]
    switch sectionType {
    case .locations:
      let item = interactor.itemFor(indexPath.item)
      
      var itemPresentation = LocationPick.ItemPresentationStyle.defaultStyle
      if indexPath.item == 0 {
        itemPresentation = .top
      }
      if indexPath.item == interactor.numberOfItems() - 1 {
        itemPresentation = .bottom
      }
      
      let vm = LocationViewModel(location: item, presentationStyle: itemPresentation)
      return .location(vm)
    }
  }
  
  func handleDoneAction() {
    
  }
  
  func handleHideAction() {
    router.dismiss()
  }
  
  func handleInputTextChange(_ text: String) {
    interactor.searchLocationsFor(text)
  }
}

// MARK: - LocationPick Viper Components

fileprivate extension LocationPickPresenter {
  var viewController: LocationPickViewControllerApi {
    return _viewController as! LocationPickViewControllerApi
  }
  var interactor: LocationPickInteractorApi {
    return _interactor as! LocationPickInteractorApi
  }
  var router: LocationPickRouterApi {
    return _router as! LocationPickRouterApi
  }
}

fileprivate struct LocationViewModel: LocationItemViewModelProtocol {
  let title: String
  
  let locationDescription: String
  
  
  let imageUrlString: String?
  
  let presentationStyle: LocationPick.ItemPresentationStyle
  
  init(location: SearchAutocompleteLocationProtocol, presentationStyle: LocationPick.ItemPresentationStyle) {
    title = location.locationTitle
    locationDescription = location.locationDescription
    imageUrlString = ""//location.images.first
    self.presentationStyle = presentationStyle
  }
}
