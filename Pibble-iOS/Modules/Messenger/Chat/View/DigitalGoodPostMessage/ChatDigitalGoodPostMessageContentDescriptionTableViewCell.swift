//
//  PostMessageContentDescriptionTableViewCell.swift
//  Pibble
//
//  Created by Sergey Kazakov on 17/02/2019.
//  Copyright © 2019 com.kazai. All rights reserved.
//

import UIKit

class ChatDigitalGoodPostMessageContentDescriptionTableViewCell: UITableViewCell, DequeueableCell {
  @IBOutlet weak var infoContentView: UIView!
  @IBOutlet weak var itemTitleLabel: UILabel!
  @IBOutlet weak var priceTitleLabel: UILabel!
  
  @IBOutlet weak var messageDateLabel: UILabel!
  
  @IBOutlet weak var pageLabel: UILabel!
  @IBOutlet weak var rewardTitleLabel: UILabel!
  @IBOutlet weak var rewardCurrencyLabel: UILabel!
  
  @IBOutlet weak var rewardLabel: UILabel!
  @IBOutlet weak var priceLabel: UILabel!
  
  @IBOutlet weak var collectionView: UICollectionView!
  @IBOutlet weak var collectionViewHeightConstraint: NSLayoutConstraint!
  
  fileprivate var handler: Chat.MessageActionHandler?
  
  
  @IBAction func buyAction(_ sender: Any) {
    handler?(self, .buy)
  }
  
  fileprivate var viewModel: ChatDigitalGoodPostMessageDescriptionViewModelProtocol? {
    didSet {
      collectionView.reloadData()
//      collectionView.collectionViewLayout.invalidateLayout()
//    
//      guard let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else {
//        return
//      }
//      
//      setNeedsLayout()
//      layoutIfNeeded()
//      let height = layout.collectionViewContentSize.height
//      collectionViewHeightConstraint.constant = bounds.size.height
    }
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
    layer.shouldRasterize = true
    layer.rasterizationScale = UIScreen.main.scale
    
    collectionView.delegate = self
    collectionView.dataSource = self
    
    collectionView.registerCell(ChatDigitalGoodPostMessageContentMediaItemCollectionViewCell.self)
    
    guard let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else {
      return
    }
    
    layout.sectionInset = UIEdgeInsets.zero
    layout.minimumLineSpacing = 0.0
    layout.minimumInteritemSpacing = 0.0
    
    infoContentView.clipsToBounds = true
    infoContentView.roundCorners([.topLeft, .topRight], radius: UIConstants.CornerRadius.contentView)
  }
  
  func setViewModel(_ vm: ChatDigitalGoodPostMessageDescriptionViewModelProtocol, handler: @escaping Chat.MessageActionHandler) {
    self.handler = handler
   
    messageDateLabel.text = vm.date
    
    itemTitleLabel.text = vm.itemTitleLabel
    priceLabel.text = vm.price
    rewardLabel.text = vm.reward
    rewardCurrencyLabel.text = vm.rewardCurrency
    rewardLabel.textColor = vm.rewardCurrencyColor
    pageLabel.isHidden = vm.mediaItemsViewModel.count <= 1
    viewModel = vm
    let idx = IndexPath(item: 0, section: 0)
    setPageForIndexPath(idx)
  }
  
  fileprivate func setPageForIndexPath(_ indexPath: IndexPath) {
    let itemsCount = collectionView.numberOfItems(inSection: indexPath.section)
    let itemNumber = indexPath.item + 1
    pageLabel.text = " \(itemNumber)/\(itemsCount) "
  }
}

extension ChatDigitalGoodPostMessageContentDescriptionTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
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
    
    let cell = collectionView.dequeueReusableCell(cell: ChatDigitalGoodPostMessageContentMediaItemCollectionViewCell.self, for: indexPath)
    let vm = viewModel.itemViewModelAt(indexPath)
    cell.setViewModel(vm)
    return cell
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return collectionView.bounds.size
  }
  
  func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
    let center = convert(collectionView.center, to: collectionView)
    guard let centerCellIndexPath = collectionView.indexPathForItem(at: center) else {
      return
    }
    
    setPageForIndexPath(centerCellIndexPath)
  }
}

fileprivate enum UIConstants {
  enum CornerRadius {
    static let contentView: CGFloat = 12.0
  }
}

