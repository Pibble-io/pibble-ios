//
//  FundingPostDetailTimeProgressTableViewCell.swift
//  Pibble-iOS
//
//  Created by Sergey Kazakov on 07/09/2019.
//  Copyright © 2019 com.kazai. All rights reserved.
//

import UIKit

class FundingPostDetailTimeProgressTableViewCell: UITableViewCell, DequeueableCell {
  @IBOutlet weak var startDateLabel: UILabel!
  @IBOutlet weak var endDateLabel: UILabel!
  
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
  
  func setViewModel(_ vm: FundingPostDetailTimeProgressStatusViewModelProtocol) {
    startDateLabel.text = vm.startedDate
    endDateLabel.text = vm.endDate
    progressBarWidthConstraint.constant = progressBarBackgroundView.bounds.width * CGFloat(vm.campaignProgress)
    
    progressBarViewProgress = CGFloat(vm.campaignProgress)
    
    [progressBarBackgroundView, progressBarView].forEach {
      $0?.clipsToBounds = true
      $0?.layer.cornerRadius = UIConstants.cornerRadius
    }
  }
}

fileprivate enum UIConstants {
  static let cornerRadius: CGFloat = 4.0
}
