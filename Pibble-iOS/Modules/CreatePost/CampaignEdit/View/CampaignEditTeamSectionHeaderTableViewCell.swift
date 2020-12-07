//
//  CampaignEditTeamSectionHeaderTableViewCell.swift
//  Pibble
//
//  Created by Kazakov Sergey on 28.10.2018.
//  Copyright © 2018 com.kazai. All rights reserved.
//

import UIKit

class CampaignEditTeamSectionHeaderTableViewCell: UITableViewCell, DequeueableCell {
  @IBOutlet weak var backgroundContainerView: UIView!
  
  override func draw(_ rect: CGRect) {
    backgroundContainerView.roundCorners([.topLeft,.topRight], radius: 5.0)
  }
}
