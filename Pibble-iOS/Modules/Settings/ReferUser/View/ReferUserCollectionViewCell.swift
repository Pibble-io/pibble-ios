//
//  ReferUserCollectionViewCell.swift
//  Pibble
//
//  Created by Sergey Kazakov on 17/05/2019.
//  Copyright © 2019 com.kazai. All rights reserved.
//

import UIKit

class ReferUserCollectionViewCell: UICollectionViewCell, DequeueableCell {
  @IBOutlet weak var userpicImageView: UIImageView!
  @IBOutlet weak var upvoteAmountLabel: UILabel!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    UIView.performWithoutAnimation { [weak self] in
      self?.userpicImageView.setCornersToCircle()
    }
  }
  
  
  func setViewModel(_ vm: ReferredUserViewModelProtocol) {
    userpicImageView.image = vm.usrepicPlaceholder
    userpicImageView.alpha = 0.0
    UIView.animate(withDuration: 0.2) { [weak self] in
      self?.userpicImageView.alpha = 1.0
    }
    userpicImageView.setCachedImageOrDownload(vm.userpicUrlString)
    upvoteAmountLabel.text = vm.username
  }
}
