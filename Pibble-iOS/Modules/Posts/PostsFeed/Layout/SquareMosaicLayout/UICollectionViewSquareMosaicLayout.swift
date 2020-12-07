//
//  Layout.swift
//  Pibble
//
//  Created by Kazakov Sergey on 20.12.2018.
//  Copyright © 2018 com.kazai. All rights reserved.
//

import UIKit

class SquareMosaicLayout: UICollectionViewLayout {
  
  fileprivate let collectionViewForcedSize: CGSize?
  fileprivate let direction: SquareMosaicDirection
  fileprivate var object: SquareMosaicObject? = nil
  
  weak var dataSource: SquareMosaicDataSource?
  weak var delegate: SquareMosaicDelegate? {
    didSet {
      delegate?.layoutContentSizeChanged(to: collectionViewContentSize)
    }
  }
  
  override  var collectionViewContentSize: CGSize {
    switch direction {
    case .horizontal:
      return collectionViewContentSizeHorizontal
    case .vertical:
      return collectionViewContentSizeVertical
    }
  }
  
  init(direction: SquareMosaicDirection = .vertical, size collectionViewForcedSize: CGSize? = nil) {
    self.collectionViewForcedSize = collectionViewForcedSize
    self.direction = direction
    super.init()
  }
  
  convenience required init?(coder aDecoder: NSCoder) {
    self.init()
  }
  
  override func prepare() {
    let numberOfItemsInSections = collectionView?.numberOfItemsInSections ?? []
    let size = collectionViewContentSize
    object = SquareMosaicObject(numberOfItemsInSections, dataSource, direction, size)
  }
  
  override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
    return object?.layoutAttributesForItem(at: indexPath)
  }
  
  override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
    return object?.layoutAttributesForElements(in: rect)
  }
  
  override func layoutAttributesForSupplementaryView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
    return object?.layoutAttributesForSupplementaryView(ofKind: elementKind, at: indexPath)
  }
  
  override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint) -> CGPoint {
    return collectionView?.contentOffset ?? CGPoint.zero
  }
}

fileprivate extension SquareMosaicLayout {
  
  var collectionViewContentSizeHorizontal: CGSize {
    let width = object?.contentSize ?? 0.0
    let height = collectionViewForcedSize?.height ?? collectionView?.collectionViewVisibleContentHeight ?? 0.0
    return CGSize(width: width, height: height)
  }
  
  var collectionViewContentSizeVertical: CGSize {
    let height = object?.contentSize ?? 0.0
    let width = collectionViewForcedSize?.width ?? collectionView?.collectionViewVisibleContentWidth ?? 0.0
    return CGSize(width: width, height: height)
  }
}

fileprivate extension UICollectionView {
  
  var collectionViewVisibleContentHeight: CGFloat {
    return bounds.height - contentInset.top - contentInset.bottom
  }
  
  var collectionViewVisibleContentWidth: CGFloat {
    return bounds.width - contentInset.left - contentInset.right
  }
}

fileprivate extension UICollectionView {
  
  var numberOfItemsInSections: [Int] {
    var array = [Int](repeating: 0, count: numberOfSections)
    for section in 0 ..< numberOfSections {
      array[section] = numberOfItems(inSection: section)
    }
    return array
  }
}
