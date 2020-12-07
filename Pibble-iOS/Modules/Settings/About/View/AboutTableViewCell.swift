//
//  AboutTableViewCell.swift
//  Pibble
//
//  Created by Sergey Kazakov on 15/05/2019.
//  Copyright © 2019 com.kazai. All rights reserved.
//

import UIKit

class AboutTableViewCell: UITableViewCell, DequeueableCell {
  @IBOutlet weak var settingsTitleLabel: UILabel!
  
  @IBOutlet weak var pickedValueLabel: UILabel!
  
  
  @IBOutlet weak var rightArrowImageView: UIImageView!
  
  @IBOutlet weak var upperSeparatorView: UIView!
  
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
  }
  
  func setViewModel(_ vm: AboutItemViewModelProtocol) {
    settingsTitleLabel.text = vm.title
    pickedValueLabel.text = vm.pickedValue
    settingsTitleLabel.textColor = vm.titleColor
    upperSeparatorView.isHidden = !vm.isUpperSeparatorVisible
    rightArrowImageView.isHidden = !vm.isRightArrowVisible
  }
  
}
