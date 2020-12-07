//
//  PostingMediaPreselectedFundingTeamTableViewCell.swift
//  Pibble-iOS
//
//  Created by Sergey Kazakov on 13/09/2019.
//  Copyright © 2019 com.kazai. All rights reserved.
//

import UIKit

class PostingMediaPreselectedFundingTeamTableViewCell:   UITableViewCell, DequeueableCell {
  @IBOutlet weak var campaignSelectionImageView: UIImageView!
  @IBOutlet weak var containerView: UIView!
  
  @IBOutlet weak var campaignLogoImageView: UIImageView!
  @IBOutlet weak var campaignTitleLabel: UILabel!
  @IBOutlet weak var teamTitleLabel: UILabel!
  @IBOutlet weak var campaignInfoLabel: UILabel!
  @IBOutlet weak var campaignGoalsLabel: UILabel!
  
  func setViewModel(_ vm: MediaPostingPreselectedFundingCmapaignViewModelProtocol) {
    campaignLogoImageView.setCornersToCircle()
    
    campaignLogoImageView.image = vm.campaignLogoPlaceholder
    campaignSelectionImageView.image = vm.selectedItemImage
    campaignSelectionImageView.isHidden = !vm.isSelected
    
    campaignLogoImageView.setCachedImageOrDownload(vm.campaignLogoURLString)
    campaignTitleLabel.text = vm.campaignTitle
    teamTitleLabel.text = vm.teamTitle
    campaignInfoLabel.attributedText = vm.campaignInfo
    campaignGoalsLabel.attributedText = vm.campaignGoals
    campaignSelectionImageView.isHidden =  !vm.isSelected
    
    containerView.layer.cornerRadius = 5.0
    containerView.clipsToBounds = true
  }
}
