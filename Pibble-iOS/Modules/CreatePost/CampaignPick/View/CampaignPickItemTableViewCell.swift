//
//  CampaignPickItemTableViewCell.swift
//  Pibble
//
//  Created by Kazakov Sergey on 29.10.2018.
//  Copyright © 2018 com.kazai. All rights reserved.
//

import UIKit

class CampaignPickItemTableViewCell: UITableViewCell, DequeueableCell {
  @IBOutlet weak var campaignSelectionImageView: UIImageView!
  
  @IBOutlet weak var campaignLogoImageView: UIImageView!
  @IBOutlet weak var campaignTitleLabel: UILabel!
  @IBOutlet weak var teamTitleLabel: UILabel!
  @IBOutlet weak var campaignInfoLabel: UILabel!
  @IBOutlet weak var campaignGoalsLabel: UILabel!
  
  func setViewModel(_ vm: CampaignPickItemViewModelProtocol) {
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
  }
}
