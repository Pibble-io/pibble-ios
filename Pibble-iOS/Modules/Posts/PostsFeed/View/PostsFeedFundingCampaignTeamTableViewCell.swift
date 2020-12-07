//
//  PostsFeedFundingCampaignTeamTableViewCell.swift
//  Pibble
//
//  Created by Kazakov Sergey on 30.10.2018.
//  Copyright © 2018 com.kazai. All rights reserved.
//

import UIKit


typealias PostsFeedFundingCampaignTeamActionHandler = (PostsFeedFundingCampaignTeamTableViewCell, PostsFeed.FundingCampaignTeamActions) -> Void


class PostsFeedFundingCampaignTeamTableViewCell: UITableViewCell, DequeueableCell {
  
  @IBOutlet weak var teamLogoImageView: UIImageView!
  @IBOutlet weak var teamNameLabel: UILabel!
  @IBOutlet weak var teamInfoLabel: UILabel!
  
  @IBOutlet weak var joinTeamButton: UIButton!
  
  @IBAction func joinAction(_ sender: Any) {
    handler?(self, .join)
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
    layer.shouldRasterize = true
    layer.rasterizationScale = UIScreen.main.scale
  }
  
  fileprivate var handler: PostsFeedFundingCampaignTeamActionHandler?
  
  func setViewModel(_ vm: PostsFeedFundingCampaignTeamViewModelProtocol, handler: @escaping PostsFeedFundingCampaignTeamActionHandler) {
    self.handler = handler
    teamNameLabel.text = vm.teamName
    teamInfoLabel.text = vm.teamInfo
  }
}
