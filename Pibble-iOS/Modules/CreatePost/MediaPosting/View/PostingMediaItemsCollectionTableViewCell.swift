//
//  PostingMediaItemsCollectionTableViewCell.swift
//  Pibble
//
//  Created by Kazakov Sergey on 13.07.2018.
//  Copyright © 2018 com.kazai. All rights reserved.
//

import UIKit

typealias PostingMediaItemsAddItemHandler = (PostingMediaItemsCollectionTableViewCell) -> Void

class PostingMediaItemsCollectionTableViewCell: UITableViewCell {
  static let identifier = "PostingMediaItemsCollectionTableViewCell"
  
  @IBOutlet weak var collectionView: UICollectionView!
  
  fileprivate var actionHandler: PostingMediaItemsAddItemHandler?
  fileprivate weak var viewModel: MediaPostingAttachedMediaViewModelProtocol?
  
  var imageRequestConfig: ImageRequestConfig = ImageRequestConfig(size: CGSize.zero, contentMode: .aspectFill)
  
  override func awakeFromNib() {
    super.awakeFromNib()
    collectionView.delegate = self
    collectionView.dataSource = self
    updateLayouts()
    
    collectionView.registerViewAsFooter(PostingMediaItemReusableView.self)
  }
  
  override var bounds: CGRect {
    didSet {
      updateLayouts()
    }
  }
  
  fileprivate func updateLayouts() {
    let inset = UIConstants.Insets.top * 2.0
    let size = CGSize(width: collectionView.bounds.height - inset, height: collectionView.bounds.height - inset)
    let enlargedSize = CGSize(width: size.width * 4, height: size.height * 4)
    imageRequestConfig = ImageRequestConfig(size: enlargedSize, contentMode: .aspectFill)
    
    guard let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else {
      return
    }
    
    layout.itemSize = size
    layout.minimumLineSpacing = UIConstants.Insets.top
    layout.minimumInteritemSpacing = UIConstants.Insets.interItems
    layout.sectionInset.left = UIConstants.Insets.left
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }
  
  func setViewModel(_ vm: MediaPostingAttachedMediaViewModelProtocol, actionHandler: @escaping PostingMediaItemsAddItemHandler ) {
    self.viewModel = vm
    collectionView.reloadData()
    self.actionHandler = actionHandler
  }
  
  fileprivate func footerActionHandler (_ footer: PostingMediaItemReusableView) {
    actionHandler?(self)
  }
}

extension PostingMediaItemsCollectionTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
  func numberOfSections(in collectionView: UICollectionView) -> Int {
    return viewModel?.numberOfMediaAttachmentSections() ?? 0
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return viewModel?.numberOfMediaAttachmentsInSection(section) ?? 0
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
    return CGSize(width: UIConstants.Footer.width, height: collectionView.bounds.height)
  }
  
  func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
    
    guard case UICollectionView.elementKindSectionFooter = kind else {
      return UICollectionReusableView()
    }
    
    guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: PostingMediaItemReusableView.reuseIdentifier, for: indexPath) as?  PostingMediaItemReusableView else {
      
      return UICollectionReusableView()
    }
    headerView.actionHandler = footerActionHandler
    
    return headerView
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let id = PostingMediaItemCollectionViewCell.identifier
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: id, for: indexPath) as! PostingMediaItemCollectionViewCell
    
    guard let itemViewModel = viewModel?.mediaAttachmentViewModelTypeAt(indexPath) else {
      return cell
    }
    
    switch itemViewModel {
    case .image(let viewModelRequest):
      let id = PostingMediaItemCollectionViewCell.identifier
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: id, for: indexPath) as! PostingMediaItemCollectionViewCell
      cell.indexPath = indexPath
      
      viewModelRequest(indexPath, imageRequestConfig) { (viewModel, idx) in
        guard cell.indexPath == idx else {
          return
        }
        cell.setViewModel(viewModel)
      }
      return cell
    }
  }
}

fileprivate enum UIConstants {
  enum Footer {
    static let width: CGFloat = 75.0
  }
  
  enum Insets {
    static let top: CGFloat = 15
    static let interItems: CGFloat = 13
    static let left: CGFloat = 10
  }
  
}
