//
//  LocationPickInteractor.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 23.07.2018.
//Copyright © 2018 com.kazai. All rights reserved.
//

import Foundation

// MARK: - LocationPickInteractor Class
final class LocationPickInteractor: Interactor {
  fileprivate var locationSuggestions: [SearchAutocompleteLocationProtocol] = []
  fileprivate let postingService: PostingServiceProtocol
  fileprivate let locationSearchService: LocationSearchServiceProtocol
  
  fileprivate var performSearchObject = DelayBlockObject()
  
  init(postingService: PostingServiceProtocol, locationSearchService: LocationSearchServiceProtocol) {
    self.postingService = postingService
    self.locationSearchService = locationSearchService
  }
}

// MARK: - LocationPickInteractor API
extension LocationPickInteractor: LocationPickInteractorApi {
  func searchLocationInformationFor(_ item: Int) {
    guard item < locationSuggestions.count else {
      return
    }
    
    locationSearchService.searchGooglePlace(locationSuggestions[item].googlePlaceId) { [weak self] in
      switch $0 {
      case .success(let location):
        self?.presenter.presentLocationInformation(location)
      case .failure(let err):
        self?.presenter.handleError(err)
      }
    }
    
  }
  
  func searchLocationsFor(_ string: String) {
    performSearchObject.cancel()
    guard string.count > 0 else {
      locationSuggestions = []
      presenter.presentLocationsCollection()
      return
    }
    
    performSearchObject.scheduleAfter(delay: 0.45) { [weak self] in
      self?.performSearchFor(string)
    }
  }
  
  func numberOfItems() -> Int {
    return locationSuggestions.count
  }
  
  func itemFor(_ item: Int) -> SearchAutocompleteLocationProtocol {
    return locationSuggestions[item]
  }
}

// MARK: - Interactor Viper Components Api

private extension LocationPickInteractor {
    var presenter: LocationPickPresenterApi {
        return _presenter as! LocationPickPresenterApi
    }
}

extension LocationPickInteractor {
  fileprivate func performSearchFor(_ location: String) {
    locationSearchService.searchLocation(location) { [weak self] in
      guard let strongSelf = self else {
        return
      }
      
      switch $0 {
      case .success(let locations):
        strongSelf.locationSuggestions = locations
        strongSelf.presenter.presentLocationsCollection()
      case .failure(let error):
        strongSelf.presenter.handleError(error)
      }
    }
  }
}
