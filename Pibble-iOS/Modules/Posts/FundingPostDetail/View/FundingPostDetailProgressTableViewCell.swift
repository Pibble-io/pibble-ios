//
//  FundingPostDetailProgressTableViewCell.swift
//  Pibble-iOS
//
//  Created by Sergey Kazakov on 07/09/2019.
//  Copyright © 2019 com.kazai. All rights reserved.
//

import UIKit

class FundingPostDetailProgressTableViewCell: UITableViewCell, DequeueableCell {
  @IBOutlet weak var raisedPerCentLabel: UILabel!
  @IBOutlet weak var raisedAmountLabel: UILabel!
  @IBOutlet weak var goalAmountLabel: UILabel!
  
  @IBOutlet weak var progressBarBackgroundView: UIView!
  
  @IBOutlet weak var progressBarView: UIView!
  
  @IBOutlet weak var progressBarWidthConstraint: NSLayoutConstraint!
  
  fileprivate var progressBarViewProgress: CGFloat = 0.0
  
  override func awakeFromNib() {
    super.awakeFromNib()
    layer.shouldRasterize = true
    layer.rasterizationScale = UIScreen.main.scale
  }
  
  override func draw(_ rect: CGRect) {
    progressBarWidthConstraint.constant = progressBarBackgroundView.bounds.width * progressBarViewProgress
  }
  
  func setViewModel(_ vm: FundingPostDetailProgressStatusViewModelProtocol) {
   
    raisedPerCentLabel.text = vm.raisedPerCent
    raisedAmountLabel.text = vm.raisedAmount
    goalAmountLabel.text = vm.goalAmount
    
    setNeedsLayout()
    layoutIfNeeded()
    
    print("width: \(progressBarBackgroundView.bounds.width), progress: \(CGFloat(vm.campaignProgress))")
    progressBarWidthConstraint.constant = progressBarBackgroundView.bounds.width * CGFloat(vm.campaignProgress)
    
    progressBarViewProgress = CGFloat(vm.campaignProgress)
    
    [progressBarBackgroundView, progressBarView].forEach {
      $0?.clipsToBounds = true
      $0?.layer.cornerRadius = UIConstants.cornerRadius
    }
    
    
    setNeedsLayout()
    layoutIfNeeded()
    
  }
}

fileprivate enum UIConstants {
  static let cornerRadius: CGFloat = 4.0
}
