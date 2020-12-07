//
//  CampaignEditTeamLogoPickerTableViewCell.swift
//  Pibble
//
//  Created by Kazakov Sergey on 28.10.2018.
//  Copyright © 2018 com.kazai. All rights reserved.
//

import UIKit

typealias CampaignEditTeamLogoPickerTableViewCellActionHandler = (CampaignEditTeamLogoPickerTableViewCell, CampaignEdit.LogoPickActions) -> Void

class CampaignEditTeamLogoPickerTableViewCell: UITableViewCell, DequeueableCell {
  @IBOutlet weak var logoPickerTitleLabel: UILabel!
  
  @IBOutlet weak var logoImageView: UIImageView!
  
  @IBAction func pickImageAction(_ sender: Any) {
    handler?(self, .pickLogoAction)
  }
  
  fileprivate var handler: CampaignEditTeamLogoPickerTableViewCellActionHandler?
  func setViewModel(_ vm: CampaignEditTeamLogoPickerViewModelProtocol, handler: @escaping CampaignEditTeamLogoPickerTableViewCellActionHandler) {
    self.handler = handler
    logoImageView.layer.borderWidth = 1.0
    logoImageView.layer.borderColor = UIColor.gray191.cgColor
    logoImageView.clipsToBounds = true
    logoImageView.contentMode = vm.teamLogo == nil ? .center : .scaleAspectFill
    logoImageView.image = vm.teamLogo ?? vm.teamLogoPlaceHolder
  }
}
