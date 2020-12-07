//
//  PostMessageContentMediaItemCollectionViewCell.swift
//  Pibble
//
//  Created by Sergey Kazakov on 17/02/2019.
//  Copyright © 2019 com.kazai. All rights reserved.
//

import UIKit

class ChatDigitalGoodPostHeaderMediaItemCollectionViewCell: UICollectionViewCell, DequeueableCell {
  @IBOutlet weak var itemImageView: UIImageView!
  
  @IBOutlet weak var resolutionTitleLabel: UILabel!
  @IBOutlet weak var formatTitleLabel: UILabel!
  
  @IBOutlet weak var resolutionLabel: UILabel!
  @IBOutlet weak var formatLabel: UILabel!
  @IBOutlet weak var dpiLabel: UILabel!
  
  @IBOutlet weak var imageBackgroundView: UIView!
  
  @IBOutlet weak var infoBackgroundView: UIView!
  
  @IBOutlet weak var imageWidthConstraint: NSLayoutConstraint!
  @IBOutlet weak var imageHeightConstraint: NSLayoutConstraint!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    layer.shouldRasterize = true
    layer.rasterizationScale = UIScreen.main.scale
  }
  
  func setViewModel(_ vm: ChatDigitalGoodPostHeaderDescriptionMediaItemViewModelProtocol) {
    infoBackgroundView.isHidden = false
    itemImageView.setCachedImageOrDownload(vm.itemImageViewURLString)
    resolutionLabel.text = vm.resolution
    formatLabel.text = vm.format
    dpiLabel.text = vm.dpi
    
    let ratio = vm.originalMediaHeight / vm.originalMediaWidth
   
    itemImageView.clipsToBounds = true
    
    if vm.originalMediaHeight.isLess(than: vm.originalMediaWidth) {
      imageWidthConstraint.constant = imageBackgroundView.bounds.width
      imageHeightConstraint.constant = imageBackgroundView.bounds.width * ratio
    } else {
      imageHeightConstraint.constant = imageBackgroundView.bounds.height
      imageWidthConstraint.constant = imageBackgroundView.bounds.height / ratio
    }
    
    imageBackgroundView.layoutIfNeeded()
  }
  
  func setViewModel(_ vm: ChatGoodsPostHeaderDescriptionMediaItemViewModelProtocol) {
    infoBackgroundView.isHidden = true
    itemImageView.setCachedImageOrDownload(vm.itemImageViewURLString)
    
    
    let ratio = vm.originalMediaHeight / vm.originalMediaWidth
    
    itemImageView.clipsToBounds = true
    
    if vm.originalMediaHeight.isLess(than: vm.originalMediaWidth) {
      imageWidthConstraint.constant = imageBackgroundView.bounds.width
      imageHeightConstraint.constant = imageBackgroundView.bounds.width * ratio
    } else {
      imageHeightConstraint.constant = imageBackgroundView.bounds.height
      imageWidthConstraint.constant = imageBackgroundView.bounds.height / ratio
    }
    
    imageBackgroundView.layoutIfNeeded()
  }
}
