//
//  CommercialPostDetailMediaItemCollectionViewCell.swift
//  Pibble
//
//  Created by Sergey Kazakov on 09/02/2019.
//  Copyright © 2019 com.kazai. All rights reserved.
//

import UIKit

class CommercialPostDetailMediaItemCollectionViewCell: UICollectionViewCell, DequeueableCell {
  @IBOutlet weak var itemImageView: UIImageView!
  
  @IBOutlet weak var resolutionTitleLabel: UILabel!
  @IBOutlet weak var dpiTitleLabel: UILabel!
  @IBOutlet weak var formatTitleLabel: UILabel!
  @IBOutlet weak var sizeTitleLabel: UILabel!
  
  @IBOutlet weak var resolutionLabel: UILabel!
  @IBOutlet weak var dpiLabel: UILabel!
  @IBOutlet weak var formatLabel: UILabel!
  @IBOutlet weak var sizeLabel: UILabel!
  
  @IBOutlet weak var imageBackgroundView: UIView!
  
  @IBOutlet weak var imageWidthConstraint: NSLayoutConstraint!
  @IBOutlet weak var imageHeightConstraint: NSLayoutConstraint!
  
  
  func setViewModel(_ vm: CommercialPostDetailMediaItemDescriptionViewModelProtocol) {
    itemImageView.setCachedImageOrDownload(vm.itemImageViewURLString)
    resolutionLabel.text = vm.resolution
    dpiLabel.text = vm.dpi
    formatLabel.text = vm.format
    sizeLabel.text = vm.size
    let ratio = vm.originalMediaHeight / vm.originalMediaWidth
    
    if vm.originalMediaHeight.isLess(than: vm.originalMediaWidth) {
      imageWidthConstraint.constant = imageBackgroundView.bounds.width
      imageHeightConstraint.constant = imageBackgroundView.bounds.width * ratio
    } else {
      imageHeightConstraint.constant = imageBackgroundView.bounds.height
      imageWidthConstraint.constant = imageBackgroundView.bounds.height / ratio
    }
  }
}
