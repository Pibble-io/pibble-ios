//
//  PostsFeedDescriptionCollectionViewCell.swift
//  Pibble
//
//  Created by Kazakov Sergey on 02.08.2018.
//  Copyright © 2018 com.kazai. All rights reserved.
//
  
import UIKit

class PostsFeedDescriptionTableViewCell: UITableViewCell, DequeueableCell {
  @IBOutlet weak var captionLabel: UILabel!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    layer.shouldRasterize = true
    layer.rasterizationScale = UIScreen.main.scale
  }
  
  func setViewModel(_ vm: PostsFeedDescriptionViewModelProtocol) {
    captionLabel.attributedText = vm.attributedCaption
  }
}
  
