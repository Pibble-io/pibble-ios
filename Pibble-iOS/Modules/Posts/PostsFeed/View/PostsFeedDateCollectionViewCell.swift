//
//  PostsFeedDateCollectionViewCell.swift
//  Pibble
//
//  Created by Kazakov Sergey on 02.08.2018.
//  Copyright © 2018 com.kazai. All rights reserved.
//

import UIKit

class PostsFeedDateTableViewCell: UITableViewCell, DequeueableCell {
  @IBOutlet weak var dateLabel: UILabel!
  @IBOutlet weak var brushCountLabel: UILabel!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    layer.shouldRasterize = true
    layer.rasterizationScale = UIScreen.main.scale
  }
  
  func setViewModel(_ vm: PostsFeedDateViewModelProtocol) {
    dateLabel.text = vm.postingDateTitle
    brushCountLabel.attributedText = vm.brushedCountAttributedTitle
  }
}
