//
//  PostsFeedFundingCampaignStatusTableViewCell.swift
//  Pibble
//
//  Created by Kazakov Sergey on 29.10.2018.
//  Copyright © 2018 com.kazai. All rights reserved.
//

import UIKit



class PostsFeedFundingCampaignStatusTableViewCell: UITableViewCell, DequeueableCell {

  @IBOutlet weak var raisedPerCentLabel: UILabel!
  @IBOutlet weak var raisedAmountLabel: UILabel!
  @IBOutlet weak var goalAmountLabel: UILabel!
  
  @IBOutlet weak var donateButton: UIButton!
  
  @IBOutlet weak var progressBarBackgroundView: UIView!
  
  @IBOutlet weak var progressBarView: UIView!
  
  @IBOutlet weak var progressBarWidthConstraint: NSLayoutConstraint!
  
  @IBAction func donateAction(_ sender: Any) {
    handler?(self, .donate)
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
    layer.shouldRasterize = true
    layer.rasterizationScale = UIScreen.main.scale
  }
  
  fileprivate var handler: PostsFeed.FundingCampaignStatusActionHandler?
  
  func setViewModel(_ vm: PostsFeedFundingCampaignStatusViewModelProtocol, handler: @escaping PostsFeed.FundingCampaignStatusActionHandler) {
    self.handler = handler
    raisedPerCentLabel.text = vm.raisedPerCent
    raisedAmountLabel.text = vm.raisedAmount
    goalAmountLabel.text = vm.goalAmount
    progressBarWidthConstraint.constant = progressBarBackgroundView.bounds.width * CGFloat(vm.campaignProgress)
    
    progressBarBackgroundView.setCornersToCircleByHeight()
    progressBarView.setCornersToCircleByHeight()
    donateButton.setCornersToCircleByHeight()
    
  }
}
