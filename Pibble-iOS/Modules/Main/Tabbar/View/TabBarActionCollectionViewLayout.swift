//
//  TabBarActionCollectionViewLayout.swift
//  Pibble
//
//  Created by Kazakov Sergey on 30.06.2018.
//  Copyright © 2018 com.kazai. All rights reserved.
//

import UIKit

class TabBarActionCollectionViewLayout: UICollectionViewFlowLayout {
  fileprivate var indexPathsToAnimate: Set<IndexPath> = Set()
  
  
  override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
    guard let collection = collectionView else {
      return true
    }
    
    return collection.bounds != newBounds
  }
  
  override func prepare(forCollectionViewUpdates updateItems: [UICollectionViewUpdateItem]) {
    super.prepare(forCollectionViewUpdates: updateItems)
    
    let items = updateItems
      .compactMap { (item) -> [IndexPath]? in
          switch item.updateAction {
          case .insert:
            guard let idx = item.indexPathAfterUpdate else {
              return nil
            }
            return [idx]
          case .delete:
            guard let idx = item.indexPathBeforeUpdate else {
              return nil
            }
            return [idx]
          case .reload:
            return nil
          case .move:
            guard let beforeIdx = item.indexPathBeforeUpdate,
                  let afterIdx = item.indexPathAfterUpdate else {
               return nil
            }
            return [beforeIdx, afterIdx]
          case .none:
            return nil
          }
        }
      .flatMap {
        return $0
      }
    
      indexPathsToAnimate = Set(items)
  }
  
  override func initialLayoutAttributesForAppearingItem(at itemIndexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
    let attributes = super.initialLayoutAttributesForAppearingItem(at: itemIndexPath)
    
    guard let _ =  indexPathsToAnimate.remove(itemIndexPath) else {
      return attributes
    }
    
    let centerX = attributes?.center.x ?? 0.0 //collectionView?.bounds.midX ?? 0.0
    let centerY = (collectionView?.bounds.maxY ?? 0.0)
    attributes?.center = CGPoint(x: centerX, y: centerY)
    attributes?.alpha = 0.0
    return attributes
  }
  
  override func finalLayoutAttributesForDisappearingItem(at itemIndexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
    let attributes = super.finalLayoutAttributesForDisappearingItem(at: itemIndexPath)
    
    guard let _ =  indexPathsToAnimate.remove(itemIndexPath) else {
      return attributes
    }
    
    let centerX = attributes?.center.x ?? 0.0 //collectionView?.bounds.midX ?? 0.0
    let centerY = (collectionView?.bounds.maxY ?? 0.0)
    attributes?.alpha = 0.0
    attributes?.center = CGPoint(x: centerX, y: centerY)
    return attributes
  }
  
}
