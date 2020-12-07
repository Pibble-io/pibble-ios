//
//  SearchResultPlaceMapViewController.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 30.12.2018.
//Copyright © 2018 com.kazai. All rights reserved.
//

import UIKit
import MapKit

//MARK: SearchResultPlaceMapView Class
final class SearchResultPlaceMapViewController: ViewController {
  
  @IBOutlet weak var navBarTitleLabel: UILabel!
  @IBOutlet weak var navBarHideButton: UIButton!
  
  @IBOutlet weak var mapView: MKMapView!
  
  
  @IBAction func hideAction(_ sender: Any) {
  }
  
  
}

//MARK: - SearchResultPlaceMapView API
extension SearchResultPlaceMapViewController: SearchResultPlaceMapViewControllerApi {
}

// MARK: - SearchResultPlaceMapView Viper Components API
fileprivate extension SearchResultPlaceMapViewController {
    var presenter: SearchResultPlaceMapPresenterApi {
        return _presenter as! SearchResultPlaceMapPresenterApi
    }
}
