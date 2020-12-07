//
//  .swift
//  Pibble
//
//  Created by Kazakov Sergey on 30.12.2018.
//  Copyright © 2018 com.kazai. All rights reserved.
//

import UIKit
import MapKit

//MARK: SearchResultPlaceMapView Class
final class SearchResultPlaceMapContentViewController: ViewController {
  //MARK:- IBOutlets
  
  @IBOutlet weak var mapView: MKMapView!
  
  //MARK:- Delegates
  
  weak var embedableDelegate: EmbedableViewControllerDelegate? 
  
  //MARK:- private properties
  
  fileprivate lazy var tapGestureRecognizer: UITapGestureRecognizer = {
    let gesture = UITapGestureRecognizer(target: self, action: #selector(tap(sender:)))
    gesture.delegate = self
    return gesture
  }()
  
  //MARK:- Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupView()
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    preferredContentSize = contentSize
  }
}

//MARK: - SearchResultPlaceMapView API
extension SearchResultPlaceMapContentViewController: SearchResultPlaceMapViewControllerApi {
  func setNavBarTitle(_ text: String) { }
  
  func showMapItem(_ mapItem: SearchResultPlaceMapItemViewModelProtocol) {
    mapView.removeAnnotations(mapView.annotations)
    if let annotation = mapItem.mapAnnotation {
      mapView.addAnnotation(annotation)
    }
    
    if let annotation = mapView.annotations.first {
      let distance = CLLocationDistance(3000)
      let region = MKCoordinateRegion(center: annotation.coordinate, latitudinalMeters: distance, longitudinalMeters: distance)
      mapView.setRegion(region, animated: true)
    }
    
    embedableDelegate?.handleContentSizeChange(self, contentSize: contentSize)
  }
}

// MARK: - SearchResultPlaceMapView Viper Components API
fileprivate extension SearchResultPlaceMapContentViewController {
  var presenter: SearchResultPlaceMapPresenterApi {
    return _presenter as! SearchResultPlaceMapPresenterApi
  }
}


//MARK:- Helpers

extension SearchResultPlaceMapContentViewController {
  @objc func tap(sender: UITapGestureRecognizer) {
    presenter.handleMapSelecion()
  }
  
  fileprivate func setupView() {
    mapView.delegate = self
    mapView.addGestureRecognizer(tapGestureRecognizer)
  }
}

//MARK:- MKMapViewDelegate

extension SearchResultPlaceMapContentViewController: MKMapViewDelegate {
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

extension SearchResultPlaceMapContentViewController: EmbedableViewController {
  func setBouncingEnabled(_ enabled: Bool) {  }
  
  var contentSize: CGSize {
    return mapView.bounds.size
  }
  
  func setScrollingEnabled(_ enabled: Bool) {  }
  
}


extension SearchResultPlaceMapContentViewController: UIGestureRecognizerDelegate {
  func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
    return true
  }
}
