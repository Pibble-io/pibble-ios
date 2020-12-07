//
//  SettingsHomeTableViewCell.swift
//  Pibble
//
//  Created by Sergey Kazakov on 15/05/2019.
//  Copyright © 2019 com.kazai. All rights reserved.
//

import UIKit

class SettingsHomeTableViewCell: UITableViewCell, DequeueableCell {
  @IBOutlet weak var settingsTitleLabel: UILabel!
  @IBOutlet weak var settingsIconImageView: UIImageView!
  
  @IBOutlet weak var rightArrowImageView: UIImageView!
  
  @IBOutlet weak var upperSeparatorView: UIView!
  
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
  }
  
  func setViewModel(_ vm: SettingsHomeItemViewModelProtocol) {
    settingsTitleLabel.text = vm.title
    settingsIconImageView.image = vm.icon
    
    settingsTitleLabel.textColor = vm.titleColor
    upperSeparatorView.isHidden = !vm.isUpperSeparatorVisible
    rightArrowImageView.isHidden = !vm.isRightArrowVisible
  }
  
}
