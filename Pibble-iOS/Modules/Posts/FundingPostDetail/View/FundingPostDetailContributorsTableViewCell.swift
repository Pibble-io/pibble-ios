//
//  FundingPostDetailContributorsTableViewCell.swift
//  Pibble-iOS
//
//  Created by Sergey Kazakov on 07/09/2019.
//  Copyright © 2019 com.kazai. All rights reserved.
//

import UIKit

class FundingPostDetailContributorsTableViewCell: UITableViewCell, DequeueableCell {
  @IBOutlet weak var contributorsCountLabel: UILabel!
  
  @IBOutlet weak var containerView: UIView!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    layer.shouldRasterize = true
    layer.rasterizationScale = UIScreen.main.scale
  }
  
  func setViewModel(_ vm: FundingPostDetailContributorsInfoViewModelProtocol) {
    contributorsCountLabel.text = vm.contributorsCount
  }
}

