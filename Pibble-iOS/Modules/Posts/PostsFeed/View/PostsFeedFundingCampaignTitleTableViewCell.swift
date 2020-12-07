//
//  PostsFeedFundingCampaignTitleTableViewCell.swift
//  Pibble
//
//  Created by Kazakov Sergey on 29.10.2018.
//  Copyright © 2018 com.kazai. All rights reserved.
//

import UIKit

class PostsFeedFundingCampaignTitleTableViewCell: UITableViewCell, DequeueableCell {
//  @IBOutlet weak var campaignImageView: UIImageView!
  @IBOutlet weak var campaignTitleLabel: UILabel!
  @IBOutlet weak var donateButtonTitleLabel: UILabel!
  @IBOutlet weak var dateLabel: UILabel!
  
  @IBAction func campaginSelectionAction(_ sender: Any) {
    handler?(self, .showCampaign)
  }
  
  fileprivate var handler: PostsFeed.FundingCampaignStatusActionHandler?
  
  override func awakeFromNib() {
    super.awakeFromNib()
    layer.shouldRasterize = true
    layer.rasterizationScale = UIScreen.main.scale
  }
  
  func setViewModel(_ vm: PostsFeedFundingCampaignTitleViewModelProtocol, handler:  @escaping PostsFeed.FundingCampaignStatusActionHandler) {
    self.handler = handler
    campaignTitleLabel.text = vm.campaignTitle
    
    donateButtonTitleLabel.text = vm.campaignDonateActionName
    dateLabel.text = vm.campaignEndingDate
    
    donateButtonTitleLabel.textColor = vm.isActive ?
      UIConstants.Colors.activeCampaign:
      UIConstants.Colors.finishedCampaign
  }
}

fileprivate enum UIConstants {
  enum Colors {
    static let activeCampaign = UIColor.bluePibble
    static let finishedCampaign = UIColor.black
  }
}
