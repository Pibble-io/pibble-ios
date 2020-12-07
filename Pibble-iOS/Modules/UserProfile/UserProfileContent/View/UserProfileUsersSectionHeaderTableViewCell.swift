//
//  UserProfileUsersSectionHeaderTableViewCell.swift
//  Pibble
//
//  Created by Kazakov Sergey on 08.11.2018.
//  Copyright © 2018 com.kazai. All rights reserved.
//

import UIKit

class UserProfileUsersSectionHeaderTableViewCell: UITableViewCell, DequeueableCell {

  @IBOutlet weak var sectionTitleLabel: UILabel!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    layer.shouldRasterize = true
    layer.rasterizationScale = UIScreen.main.scale
  }
  
  func setViewModel(_ vm: UserProfileUsersSectionHeaderViewModelProtocol) {
    sectionTitleLabel.text = vm.title
  }
}
