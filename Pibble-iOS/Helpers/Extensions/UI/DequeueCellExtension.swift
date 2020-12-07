//
//  UICollectionViewCellExtension.swift
//  Pibble
//
//  Created by Kazakov Sergey on 06.08.2018.
//  Copyright © 2018 com.kazai. All rights reserved.
//

import UIKit

protocol DequeueableCell {
  
}

extension DequeueableCell {
  static var cellIdentifier: String {
    return String(describing: self)
  }
}

extension UICollectionView {
  func dequeueReusableCell<T>(cell: T.Type, for indexPath: IndexPath) -> T
    where T: DequeueableCell, T: UICollectionViewCell
  {
    let cell = dequeueReusableCell(withReuseIdentifier: cell.cellIdentifier, for: indexPath)
    return cell as! T
    
  }
  
  func registerCell<T>(_ cell: T.Type) where T: DequeueableCell, T: UICollectionViewCell {
    let nib = UINib(nibName: cell.cellIdentifier, bundle: nil)
    register(nib, forCellWithReuseIdentifier: cell.cellIdentifier)
  }
}

extension UITableView {
  func dequeueReusableCell<T>(cell: T.Type, for indexPath: IndexPath) -> T
    where T: DequeueableCell, T: UITableViewCell
  {
    let cell = dequeueReusableCell(withIdentifier: cell.cellIdentifier, for: indexPath)
    return cell as! T
  }
  
  func registerCell<T>(_ cell: T.Type) where T: DequeueableCell, T: UITableViewCell {
    let nib = UINib(nibName: cell.cellIdentifier, bundle: nil)
    register(nib, forCellReuseIdentifier: cell.cellIdentifier)
  }
}

