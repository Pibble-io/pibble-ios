//
//  WalletHomeActionCollectionViewCell.swift
//  Pibble
//
//  Created by Kazakov Sergey on 23.08.2018.
//  Copyright © 2018 com.kazai. All rights reserved.
//

import UIKit

class WalletHomeActionCollectionViewCell: UICollectionViewCell, DequeueableCell {
  
  @IBOutlet weak var actionImageView: UIImageView!
  @IBOutlet weak var actionTitleLabel: UILabel!
  
  @IBOutlet weak var badgeLabel: UILabel!
  
  func setViewModel(_ vm: WalletHomeActionViewModelProtocol) {
    actionImageView.image = vm.image
    actionTitleLabel.text = vm.title
    badgeLabel.setCornersToCircle()
    
    let newText = vm.badgeTitle ?? ""
    let hasChange = badgeLabel?.text != newText
    let shouldShow = vm.badgeTitle != nil
    
    badgeLabel.text = newText
    badgeLabel.alpha = shouldShow ? 1.0 : 0.0
    
    if shouldShow, hasChange, let badgeView = badgeLabel {
      badgeView.bubbleAnimate()
    }
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
  }
  
  override var isHighlighted: Bool {
    didSet {
      let scale: CGFloat = isHighlighted ? 0.90 : 1.0
      UIView.animate(withDuration: 0.15, animations: {[weak self] in
        self?.transform = CGAffineTransform(scaleX: scale, y: scale)
      }) { (_) in
        
      }
    }
  }
}
