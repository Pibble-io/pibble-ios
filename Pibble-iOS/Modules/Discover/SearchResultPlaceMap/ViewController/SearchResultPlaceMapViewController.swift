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
  
  //MARL:- IBOutlets
  
  @IBOutlet weak var navBarTitleLabel: UILabel!
  @IBOutlet weak var navBarHideButton: UIButton!
  
  @IBOutlet weak var mapView: MKMapView!
  
  //MARK:- IBActions
  
  @IBAction func hideAction(_ sender: Any) {
    presenter.handleHideAction()
  }
  
  //MARK:- Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupView()
  }
  
  //MARK:- Overrides
  
  override var shouldHandleSwipeToPopGesture: Bool {
    return true
  }
}

//MARK: - SearchResultPlaceMapView API
extension SearchResultPlaceMapViewController: SearchResultPlaceMapViewControllerApi {
  func setNavBarTitle(_ text: String) {
    navBarTitleLabel.text = text
  }
  
  func showMapItem(_ mapItem: SearchResultPlaceMapItemViewModelProtocol) {
    mapView.removeAnnotations(mapView.annotations)
    if let annotation = mapItem.mapAnnotation {
      mapView.addAnnotation(annotation)
    }
    
    if let annotation = mapView.annotations.first {
      let distance = CLLocationDistance(3000)
      let region = MKCoordinateRegion.init(center: annotation.coordinate, latitudinalMeters: distance, longitudinalMeters: distance)
      mapView.setRegion(region, animated: true)
    }
  }

}

// MARK: - SearchResultPlaceMapView Viper Components API
fileprivate extension SearchResultPlaceMapViewController {
    var presenter: SearchResultPlaceMapPresenterApi {
        return _presenter as! SearchResultPlaceMapPresenterApi
    }
}


//MARK:- Helpers

extension SearchResultPlaceMapViewController {
  fileprivate func setupView() {
    mapView.delegate = self
  }
}

//MARK:- MKMapViewDelegate

extension SearchResultPlaceMapViewController: MKMapViewDelegate {
  func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
    let viewModel = presenter.viewModelItemFor(annotation)
    let annotationView = mapView.dequeueReusableAnnotationView(SearchResultPlaceMapItemView.self, for: annotation)
    
    annotationView.canShowCallout = true
    annotationView.calloutOffset = CGPoint(x: 0, y: -5)
    annotationView.image = viewModel?.image
    
    return annotationView
  }
  
  
  func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
    guard let annotation = view.annotation else {
      return
    }
    
    let placeMark = MKPlacemark(coordinate: annotation.coordinate)
    let mapItem = MKMapItem(placemark: placeMark)
    mapItem.name = annotation.title ?? ""
    
    mapItem.openInMaps(launchOptions: nil)
  }
}
