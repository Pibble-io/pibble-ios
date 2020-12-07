//
//  FundingPostDetailFinishStatsTableViewCell.swift
//  Pibble-iOS
//
//  Created by Sergey Kazakov on 07/09/2019.
//  Copyright © 2019 com.kazai. All rights reserved.
//

import UIKit

class FundingPostDetailFinishStatsTableViewCell: UITableViewCell, DequeueableCell {
  @IBOutlet weak var goalLabel: UILabel!
  @IBOutlet weak var raisedLabel: UILabel!
  @IBOutlet weak var finishDateLabel: UILabel!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    layer.shouldRasterize = true
    layer.rasterizationScale = UIScreen.main.scale
  }
  
  func setViewModel(_ vm: FundingPostDetailFinishStatsViewModelProtocol) {
    goalLabel.text = vm.goal
    raisedLabel.text = vm.raised
    finishDateLabel.text = vm.finishDate
  }
}

