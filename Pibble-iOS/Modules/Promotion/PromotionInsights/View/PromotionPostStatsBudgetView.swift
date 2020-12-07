//
//  PromotionPostStatsBudgetView.swift
//  Pibble
//
//  Created by Sergey Kazakov on 12/06/2019.
//  Copyright © 2019 com.kazai. All rights reserved.
//

import UIKit



class PromotionPostStatsBudgetView: NibLoadingView {
  @IBOutlet fileprivate var contentView: UIView!
  @IBOutlet weak var budgetAmountLabel: UILabel!
  
  @IBOutlet weak var progressBarUsedLabel: UILabel!
  @IBOutlet weak var progressBarLeftLabel: UILabel!
  
  @IBOutlet weak var progressBarBackgroundView: UIView!
  @IBOutlet weak var progressBarView: UIView!
  @IBOutlet weak var progressBarViewWidthConstraint: NSLayoutConstraint!
  
  @IBOutlet weak var totalBudgetAmountLabel: UILabel!
  @IBOutlet weak var usedBudgetAmoutLabel: UILabel!
  @IBOutlet weak var leftBudgetAmountLabel: UILabel!
  
  fileprivate var progressBarViewProgress: CGFloat = 0.0
  
  override func draw(_ rect: CGRect) {
    progressBarViewWidthConstraint.constant = progressBarBackgroundView.bounds.width * CGFloat(progressBarViewProgress)
  }
  
  func setViewModel(_ vm: PromotionPostStatsBudgetViewModelProtocol) {
    budgetAmountLabel.text = vm.budgetAmount
    
    progressBarUsedLabel.text = vm.usedBudgetProgress
    progressBarLeftLabel.text = vm.leftBudgetProgress
    
    progressBarViewWidthConstraint.constant = progressBarBackgroundView.bounds.width * CGFloat(vm.progress)
    progressBarViewProgress = CGFloat(vm.progress)
    totalBudgetAmountLabel.text = vm.totalBudgetAmount
    usedBudgetAmoutLabel.text = vm.usedBudgetAmount
    leftBudgetAmountLabel.text = vm.leftBudgetAmount
  }
  
}
