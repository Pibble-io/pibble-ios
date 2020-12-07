//
//  PostingMediaFooterItemTableViewCell.swift
//  Pibble-iOS
//
//  Created by Sergey Kazakov on 03/09/2019.
//  Copyright © 2019 com.kazai. All rights reserved.
//

import UIKit

class PostingMediaFooterItemTableViewCell: UITableViewCell, DequeueableCell {
  @IBOutlet weak var backgroundContainerView: UIView!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    layer.shouldRasterize = true
    layer.rasterizationScale = UIScreen.main.scale
  }
  
  override func draw(_ rect: CGRect) {
    backgroundContainerView.roundCorners([.bottomLeft,.bottomRight], radius: 5.0)
  }
}
