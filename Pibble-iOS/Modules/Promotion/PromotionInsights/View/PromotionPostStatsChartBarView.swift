//
//  PromotionPostStatsChartBarView.swift
//  Pibble
//
//  Created by Sergey Kazakov on 12/06/2019.
//  Copyright © 2019 com.kazai. All rights reserved.
//

import UIKit


class PromotionPostStatsChartBarView: NibLoadingView {
  @IBOutlet fileprivate var contentView: UIView!
  
  @IBOutlet weak var barValueLabel: UILabel!
  
  @IBOutlet weak var barTitleLabel: UILabel!
  
  @IBOutlet weak var barView: UIView!
  
  @IBOutlet weak var barViewContainer: UIView!
  @IBOutlet weak var barViewHeightConstraint: NSLayoutConstraint!
  
  func setViewModel(_ vm: PromotionPostStatsChartBarViewModelProtocol) {
    barViewHeightConstraint.constant = barViewContainer.bounds.height * CGFloat(vm.relativeValue)
    barView.backgroundColor = vm.barColor
    barTitleLabel.text = vm.title
    barValueLabel.text = vm.value
    
    barTitleLabel.textColor = vm.titleColor
  }
}
