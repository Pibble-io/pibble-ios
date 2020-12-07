//
//  CampaignEditTeamItemTableViewCell.swift
//  Pibble
//
//  Created by Kazakov Sergey on 27.10.2018.
//  Copyright © 2018 com.kazai. All rights reserved.
//

import UIKit

class CampaignEditTeamItemTableViewCell: UITableViewCell, DequeueableCell {
  @IBOutlet weak var teamImageView: UIImageView!
  @IBOutlet weak var teamTypeLabel: UILabel!
  @IBOutlet weak var teamDescriptionLabel: UILabel!
  @IBOutlet weak var teamAdditionalDescriptionLabel: UILabel!
  
  func setViewModel(_ vm: CampaignEditTeamItemViewModelProtocol) {
    teamImageView.image = vm.teamTypeImageView
    teamTypeLabel.text = vm.teamTypeTitle
    teamDescriptionLabel.text = vm.teamDescription
    teamAdditionalDescriptionLabel.text = vm.teamAdditionDescription
  }
}
