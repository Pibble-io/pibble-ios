//
//  GooglePlacesLocationSearchService.swift
//  Pibble
//
//  Created by Kazakov Sergey on 21.08.2018.
//  Copyright © 2018 com.kazai. All rights reserved.
//

import Foundation
import GooglePlaces

class GooglePlacesLocationSearchService: NSObject, LocationSearchServiceProtocol {
  fileprivate let sessionTokenExpiration: TimeInterval = 60 * 2
  fileprivate var sessionTimestamp: Date?
  fileprivate var sessionToken: GMSAutocompleteSessionToken?
 
  init(APIKey: String) {
    GMSPlacesClient.provideAPIKey(APIKey)
  }
  
  fileprivate func getSessionToken(forceNewSession: Bool) -> GMSAutocompleteSessionToken {
    guard !forceNewSession,
      let token = sessionToken,
      let timestamp = sessionTimestamp,
      abs(timestamp.timeIntervalSinceNow) < sessionTokenExpiration else {
        let newToken = GMSAutocompleteSessionToken()
        sessionToken = newToken
        sessionTimestamp = Date()
        return newToken
    }
    
    sessionToken = nil
    sessionTimestamp = nil
    return token
  }
  
  func searchLocation(_ location: String, complete: @escaping
    ResultCompleteHandler<[SearchAutocompleteLocationProtocol], PibbleError>) {
    
    GMSPlacesClient.shared().findAutocompletePredictions(fromQuery: location, bounds: nil, boundsMode: GMSAutocompleteBoundsMode.restrict, filter: nil, sessionToken: getSessionToken(forceNewSession: true)) { predictions, error in
      
      guard let predictions = predictions else {
        complete(Result(error: .googlePlaceSearchError(error)))
        return
      }
      
      let filteredPredictions = predictions.filter { $0.placeID.count > 0 }
      complete(Result(value: filteredPredictions))
    }
  }
  
  func searchGooglePlace(_ placeId: String, complete: @escaping
    ResultCompleteHandler<SearchLocationProtocol, PibbleError>) {
    
    let fields: GMSPlaceField = GMSPlaceField(rawValue:
      UInt(GMSPlaceField.name.rawValue) |
      UInt(GMSPlaceField.placeID.rawValue) |
      UInt(GMSPlaceField.formattedAddress.rawValue) |
      UInt(GMSPlaceField.coordinate.rawValue))!
    
    GMSPlacesClient.shared().fetchPlace(fromPlaceID: placeId, placeFields: fields, sessionToken: getSessionToken(forceNewSession: false)) {
      guard let place = $0 else {
        complete(Result(error: .googlePlaceSearchError($1)))
        return
      }
      
      complete(Result(value: place))
    }
  }
}

extension GMSPlace: SearchLocationProtocol {
  var coordinates: CLLocationCoordinate2D {
    return coordinate
  }
  
  var googlePlaceId: String {
    return placeID ?? ""
  }
  
  var locationTitle: String {
    return name ?? ""
  }
  
  var locationDescription: String {
    return formattedAddress ?? ""
  }
}

extension GMSAutocompletePrediction: SearchAutocompleteLocationProtocol {
  var googlePlaceId: String {
    return placeID
  }
  
  var locationTitle: String {
    return attributedPrimaryText.string
  }
  
  var locationDescription: String {
    return attributedSecondaryText?.string ?? ""
  }
}
