//
//  FundingPostDetailTeamTableViewCell.swift
//  Pibble-iOS
//
//  Created by Sergey Kazakov on 07/09/2019.
//  Copyright © 2019 com.kazai. All rights reserved.
//

import UIKit

class FundingPostDetailTeamTableViewCell: UITableViewCell, DequeueableCell {
  @IBOutlet weak var teamNameLabel: UILabel!
  @IBOutlet weak var teamInfoLabel: UILabel!
  
  @IBOutlet weak var joinTeamButton: UIButton!
  
  @IBAction func joinAction(_ sender: Any) {
    handler?(self, .postForTeam)
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
    layer.shouldRasterize = true
    layer.rasterizationScale = UIScreen.main.scale
  }
  
  fileprivate var handler: FundingPostDetail.ActionHandler?
  
  func setViewModel(_ vm: FundingPostDetailTeamViewModelProtocol, handler: @escaping FundingPostDetail.ActionHandler) {
    self.handler = handler
    teamNameLabel.text = vm.teamName
    teamInfoLabel.text = vm.teamInfo
    
    joinTeamButton.layer.cornerRadius = 4
    joinTeamButton.clipsToBounds = true
    joinTeamButton.layer.borderWidth = 1
    joinTeamButton.layer.borderColor = UIColor.bluePibble.cgColor
  }
}

