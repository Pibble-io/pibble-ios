//
//  WalletPreviewItemCollectionViewCell.swift
//  Pibble
//
//  Created by Kazakov Sergey on 15.10.2018.
//  Copyright © 2018 com.kazai. All rights reserved.
//

import UIKit

class WalletPreviewItemCollectionViewCell: UICollectionViewCell, DequeueableCell {
    
  @IBOutlet weak var itemImageView: UIImageView!
  @IBOutlet weak var itemAmountLabel: UILabel!
  @IBOutlet weak var itemTitleLabel: UILabel!
  
  func setViewModel(_ vm: WalletPreviewItemViewModelProtocol) {
    itemImageView.image = vm.itemImage
    itemAmountLabel.text = vm.itemAmount
    itemTitleLabel.text = vm.itemTitle
  }
}
