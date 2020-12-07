//
//  UserProfileLevelTableViewCell.swift
//  Pibble
//
//  Created by Kazakov Sergey on 06.11.2018.
//  Copyright © 2018 com.kazai. All rights reserved.
//

import UIKit

class UserProfileLevelTableViewCell: UITableViewCell, DequeueableCell {
  
  @IBOutlet var statusTitleLabels: [UILabel]!
  
  @IBOutlet var amountLabels: [UILabel]!
  
  @IBOutlet var amountTargetLabels: [UILabel]!
  @IBOutlet var perCentLabels: [UILabel]!
  
  @IBOutlet var progressBarBackgroundViews: [UIView]!
  
  @IBOutlet var progressBarViews: [UIView]!
  
  @IBOutlet var progressBarWidthConstraints: [NSLayoutConstraint]!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    layer.shouldRasterize = true
    layer.rasterizationScale = UIScreen.main.scale
  }
  
  func setViewModel(_ vm: UserProfileLevelViewModelProtocol) {
    let viewModelItemsCount = vm.levelItems.count
    
    guard viewModelItemsCount == statusTitleLabels.count,
          viewModelItemsCount == amountLabels.count,
          viewModelItemsCount == amountTargetLabels.count,
          viewModelItemsCount == perCentLabels.count,
          viewModelItemsCount == progressBarWidthConstraints.count,
            viewModelItemsCount == progressBarBackgroundViews.count else {
        return
    }
    
    contentView.setNeedsLayout()
    contentView.layoutIfNeeded()
    
    for (idx, viewModel) in vm.levelItems.enumerated() {
      progressBarBackgroundViews[idx].layer.cornerRadius = progressBarBackgroundViews[idx].bounds.height * 0.5
      progressBarBackgroundViews[idx].clipsToBounds = true
      
      progressBarViews[idx].layer.cornerRadius = progressBarViews[idx].bounds.height * 0.5
      progressBarViews[idx].clipsToBounds = true
      
      
      statusTitleLabels[idx].text = viewModel.statusTitle
      amountLabels[idx].text = viewModel.amount
      amountTargetLabels[idx].text = viewModel.amountTarget
      perCentLabels[idx].text = viewModel.progressPerCentAmount
      progressBarViews[idx].backgroundColor = viewModel.progressBarColor
      progressBarWidthConstraints[idx].constant = progressBarBackgroundViews[idx].bounds.width * CGFloat(viewModel.progressBarValue)
    }
  }
}
