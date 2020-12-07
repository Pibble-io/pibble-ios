//
//  NotificationsFeedSectionHeaderView.swift
//  Pibble
//
//  Created by Sergey Kazakov on 28/06/2019.
//  Copyright © 2019 com.kazai. All rights reserved.
//

import UIKit

class NotificationsFeedSectionHeaderView: UITableViewHeaderFooterView, DequeueableView {
  @IBOutlet weak var headerTitleLabel: UILabel!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    layer.shouldRasterize = true
    layer.rasterizationScale = UIScreen.main.scale
  }
  
  func setTitle(_ title: String) {
    headerTitleLabel.text = title
  }
}
