//
//  UICollectionViewExtensions.swift
//  Pibble
//
//  Created by Kazakov Sergey on 14.08.2018.
//  Copyright © 2018 com.kazai. All rights reserved.
//

import UIKit

extension UICollectionView {
  func scrollToBottom(at: UICollectionView.ScrollPosition, animated: Bool) {
    let section = numberOfSections - 1
    let item = numberOfItems(inSection: section) - 1
    let indexPath = IndexPath(item: item, section: section)
    scrollToItem(at: indexPath, at: at, animated: animated)
  }
}
