//
//  PromotionPostEngagementView.swift
//  Pibble
//
//  Created by Sergey Kazakov on 12/06/2019.
//  Copyright © 2019 com.kazai. All rights reserved.
//

import UIKit



class PromotionPostStatsChartContainerView: NibLoadingView {
  @IBOutlet fileprivate var contentView: UIView!
  
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var amountLabel: UILabel!
  
  @IBOutlet weak var stackView: UIStackView!
  
  func setViewModel(_ vm: PromotionPostStatsChartContainerViewModelProtocol) {
    titleLabel.text = vm.title
    amountLabel.text = vm.value
    
    let barViews: [UIView] = vm.barsViewModels.map {
      let barView = PromotionPostStatsChartBarView()
      barView.setViewModel($0)
      return barView
    }
    
    barViews.forEach { stackView.addArrangedSubview($0) }
  }
}
