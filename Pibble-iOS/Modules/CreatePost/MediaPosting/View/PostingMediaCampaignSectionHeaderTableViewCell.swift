//
//  PostingMediaCampaignSectionHeaderTableViewCell.swift
//  Pibble
//
//  Created by Kazakov Sergey on 04.12.2018.
//  Copyright © 2018 com.kazai. All rights reserved.
//

import UIKit

class PostingMediaCampaignSectionHeaderTableViewCell: UITableViewCell, DequeueableCell {
  @IBOutlet weak var containerView: UIView!
  
  override func awakeFromNib() {
    super.awakeFromNib()
  }
  
  override func draw(_ rect: CGRect) {
    containerView.roundCorners([.topLeft, .topRight], radius: UIConstants.cornerRadius)
  }
}

fileprivate enum UIConstants {
  static let cornerRadius: CGFloat = 5.0
}
