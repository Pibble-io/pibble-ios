//
//  DequeueableView.swift
//  Pibble
//
//  Created by Kazakov Sergey on 20.08.2018.
//  Copyright © 2018 com.kazai. All rights reserved.
//

import UIKit
import MapKit

protocol DequeueableView {
  
}

extension DequeueableView {
  static var reuseIdentifier: String {
    return String(describing: self)
  }
}

extension UITableView {
  func registerViewAsHeader<T>(_ view: T.Type) where T: DequeueableView, T: UIView {
    let headerNib = UINib(nibName: view.reuseIdentifier, bundle: nil)
    register(headerNib, forHeaderFooterViewReuseIdentifier: view.reuseIdentifier)
  }
  
  func registerViewAsFooter<T>(_ view: T.Type) where T: DequeueableView, T: UIView {
    //it does not matter for tablewview
    registerViewAsHeader(view)
  }
  
  func dequeueReusableHeader<T>(_ view: T.Type) -> T where T: DequeueableView, T: UIView {
    let headerView = dequeueReusableHeaderFooterView(withIdentifier: view.reuseIdentifier) as! T
    return headerView
  }
  
  func dequeueReusableFooter<T>(_ view: T.Type) -> T where T: DequeueableView, T: UIView {
    return dequeueReusableHeader(view)
  }
}

extension UICollectionView {
  enum SupplementaryViewKind: String {
    case header
    case footer
    
    var keyString: String {
      switch self {
      case .header:
        return UICollectionView.elementKindSectionHeader
      case .footer:
        return UICollectionView.elementKindSectionFooter
      }
    }
  }
  
  func registerViewAsHeader<T>(_ view: T.Type) where T: DequeueableView, T: UICollectionReusableView {
    let headerNib = UINib(nibName: view.reuseIdentifier, bundle: nil)
    register(headerNib, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: view.reuseIdentifier)
  }
  
  func registerViewAsFooter<T>(_ view: T.Type) where T: DequeueableView, T: UICollectionReusableView {
    let headerNib = UINib(nibName: view.reuseIdentifier, bundle: nil)
    register(headerNib, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: view.reuseIdentifier)
  }
  
  func dequeueReusableSupplementaryView<T>(_ view: T.Type, kind: SupplementaryViewKind, for indexPath: IndexPath) -> T where T: DequeueableView, T: UICollectionReusableView {
    
    let headerView = dequeueReusableSupplementaryView(ofKind: kind.keyString, withReuseIdentifier: view.reuseIdentifier, for: indexPath) as! T
   
    return headerView
  }
}

extension MKMapView {
  func dequeueReusableAnnotationView<T>(_ view: T.Type, for annotaion: MKAnnotation) -> T where T: DequeueableView, T: MKAnnotationView {
    guard let annotationView = dequeueReusableAnnotationView(withIdentifier: view.reuseIdentifier) else {
      let view = T(annotation: annotaion, reuseIdentifier: view.reuseIdentifier)
      return view
    }
    
    annotationView.annotation = annotaion
    return annotationView as! T
  }
}
