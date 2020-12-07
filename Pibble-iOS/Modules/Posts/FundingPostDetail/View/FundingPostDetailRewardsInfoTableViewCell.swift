//
//  FundingPostDetailRewardsInfoTableViewCell.swift
//  Pibble-iOS
//
//  Created by Sergey Kazakov on 07/09/2019.
//  Copyright © 2019 com.kazai. All rights reserved.
//

import UIKit

class FundingPostDetailRewardsInfoTableViewCell: UITableViewCell, DequeueableCell {
  @IBOutlet var rewardTypeLabels: [UILabel]!
  @IBOutlet var rewardPriceLabels: [UILabel]!
  @IBOutlet var rewardAmountLabels: [UILabel]!
  @IBOutlet var rewardSelectionView: [UIView]!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    layer.shouldRasterize = true
    layer.rasterizationScale = UIScreen.main.scale
    
    rewardSelectionView.forEach {
      $0.setCornersToCircleByHeight()
      $0.layer.borderWidth = 1.0
      $0.layer.borderColor = UIConstants.Colors.selected.cgColor
    }
  }
  
  func setViewModel(_ vm: FundingPostDetailRewardsInfoViewModelProtocol) {
    vm.rewards.enumerated().forEach {
      
      rewardTypeLabels[$0.offset].text = $0.element.rewardTitle
      rewardPriceLabels[$0.offset].text = $0.element.rewardsPrice
      rewardAmountLabels[$0.offset].text = $0.element.rewardAmount
      rewardSelectionView[$0.offset].isHidden = !$0.element.isSelected
      
      let textColor = $0.element.isSelected ?
        UIConstants.Colors.selected:
        UIConstants.Colors.deselected
      
      let labels = [rewardTypeLabels[$0.offset], rewardPriceLabels[$0.offset], rewardAmountLabels[$0.offset]]
      
      labels.forEach {
        $0.textColor = textColor
      }
      
    }
  }
}



fileprivate enum UIConstants {
  enum Colors {
    static let selected = UIColor.bluePibble
    static let deselected = UIColor.gray175
  }
}
