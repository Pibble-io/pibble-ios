//
//  SignUpCountriesTableViewCell.swift
//  Pibble
//
//  Created by Kazakov Sergey on 19.06.2018.
//  Copyright © 2018 com.kazai. All rights reserved.
//

import UIKit
import Kingfisher

class SignUpCountriesTableViewCell: UITableViewCell {
  static let identifier = "SignUpCountriesTableViewCell"
  
  @IBOutlet weak var countryImageView: UIImageView!
  @IBOutlet weak var countryTitleLabel: UILabel!
  @IBOutlet weak var countryCodeLabel: UILabel!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
    
    selectedBackgroundView = UIView()
    selectedBackgroundView?.backgroundColor = UIColor.bluePibble
  }
 
  func setViewModel(_ vm: SignUpCountryViewModelProtocol) {
    countryCodeLabel.text = vm.countryCode
    countryTitleLabel.text = vm.countryTitle
  }
  
}
