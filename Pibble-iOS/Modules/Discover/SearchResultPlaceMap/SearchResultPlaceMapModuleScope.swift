//
//  SearchResultPlaceMapModuleScope.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 30.12.2018.
//Copyright © 2018 com.kazai. All rights reserved.
//

import Foundation
import MapKit

enum SearchResultPlaceMap {
  class MapAnnotation: NSObject, MKAnnotation {
    let coordinate: CLLocationCoordinate2D
    let title: String?
    let subtitle: String?
    
    init?(place: LocationProtocol) {
      guard let lat = Double(place.placeLatitude),
        let lng = Double(place.placeLongitude) else {
          return nil
      }
      
      coordinate = CLLocationCoordinate2D(latitude: lat, longitude: lng)
      title = place.locationDescription
      subtitle = ""
    }
  }
  
  struct ItemViewModel: SearchResultPlaceMapItemViewModelProtocol {
    let mapAnnotation: MKAnnotation?
    let image: UIImage?
    let title: String
    
    init(place: LocationProtocol) {
      mapAnnotation = MapAnnotation(place: place)
      title = place.locationDescription
      image = UIImage(imageLiteralResourceName: "SearchResultPlaceMap-MapItem")
    }
  }
}
