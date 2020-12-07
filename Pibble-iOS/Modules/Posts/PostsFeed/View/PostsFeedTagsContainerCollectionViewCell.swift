//
//  PostsFeedTagsContainerCollectionViewCell.swift
//  Pibble
//
//  Created by Kazakov Sergey on 08.08.2018.
//  Copyright © 2018 com.kazai. All rights reserved.
//

import UIKit

typealias PostsFeedTagsContainerActionHandler = (PostsFeedTagsContainerTableViewCell, IndexPath) -> Void

class PostsFeedTagsContainerTableViewCell: UITableViewCell, DequeueableCell {
  @IBOutlet weak var collectionView: UICollectionView!
  @IBOutlet weak var collectionViewHeightConstraint: NSLayoutConstraint!
  
  
  fileprivate var viewModel: PostsFeedTagContainerViewModelProtocol? {
    didSet {
      collectionView.reloadData()
      collectionView.collectionViewLayout.invalidateLayout()
      
      guard let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else {
        return
      }
      setNeedsLayout()
      layoutIfNeeded()
      collectionViewHeightConstraint.constant = layout.collectionViewContentSize.height
     
    }
  }
  
  fileprivate var handler: PostsFeedTagsContainerActionHandler?
  
  override func awakeFromNib() {
    super.awakeFromNib()
    layer.shouldRasterize = true
    layer.rasterizationScale = UIScreen.main.scale
    
    collectionView.delegate = self
    collectionView.dataSource = self
    collectionView.registerCell(PostsFeedTagCollectionViewCell.self)
    
    guard let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else {
      return
    }
    
    layout.itemSize = UICollectionViewFlowLayout.automaticSize
    layout.estimatedItemSize = CGSize(width: 100.0, height: 30.0)
    layout.sectionInset = UIEdgeInsets.zero
    layout.minimumLineSpacing = 10.0
    layout.minimumInteritemSpacing = 5.0
  }
  
  func setViewModel(_ vm: PostsFeedTagContainerViewModelProtocol, handler: @escaping PostsFeedTagsContainerActionHandler) {
    self.handler = handler
    viewModel = vm
  }
}

extension PostsFeedTagsContainerTableViewCell: UICollectionViewDataSource, UICollectionViewDelegate {
  func numberOfSections(in collectionView: UICollectionView) -> Int {
    return viewModel?.numberOfSections() ?? 0
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return viewModel?.numberOfItemsInSection(section) ?? 0
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let viewModel = viewModel else {
      return UICollectionViewCell()
    }
    
    let itemVM = viewModel.itemViewModelAt(indexPath)
    let cell = collectionView.dequeueReusableCell(cell: PostsFeedTagCollectionViewCell.self, for: indexPath)
    cell.setViewModel(itemVM, handler: tagSelectionHandler)
    return cell
  }
}

extension PostsFeedTagsContainerTableViewCell {
  func tagSelectionHandler(_ cell: PostsFeedTagCollectionViewCell) {
    guard let indexPath = collectionView.indexPath(for: cell) else {
      return
    }
    
    handler?(self, indexPath)
  }
}


