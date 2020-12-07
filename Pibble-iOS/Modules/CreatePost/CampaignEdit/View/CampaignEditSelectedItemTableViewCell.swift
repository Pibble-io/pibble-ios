//
//  CampaignEditExpandingSectionInputTitleTableViewCell.swift
//  Pibble
//
//  Created by Kazakov Sergey on 24.10.2018.
//  Copyright © 2018 com.kazai. All rights reserved.
//

import UIKit

class CampaignEditSelectedItemTableViewCell: UITableViewCell, DequeueableCell {
  @IBOutlet weak var sectionTitleLabel: UILabel!
  
  @IBOutlet weak var backgroundContainerView: UIView!
  func setViewModel(_ vm: CampaignEditSelectedItemViewModelProtocol) {
    sectionTitleLabel.attributedText = vm.attributedTitle
    
    backgroundContainerView.layer.cornerRadius = 4.0
    backgroundContainerView.clipsToBounds = true
  }
  
}
