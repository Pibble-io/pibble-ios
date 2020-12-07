//
//  PostingMediaLocationTableViewCell.swift
//  Pibble
//
//  Created by Kazakov Sergey on 16.07.2018.
//  Copyright © 2018 com.kazai. All rights reserved.
//

import UIKit

class PostingMediaLocationTableViewCell: UITableViewCell {
  static let identifier = "PostingMediaLocationTableViewCell"
  
  @IBOutlet weak var containerView: UIView!
  @IBOutlet weak var locationLabel: UILabel!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
    containerView.clipsToBounds = true
    containerView.layer.cornerRadius = UIConstants.cornerRadius
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }
  
  func setViewModel(_ vm: MediaPostingLocationViewModelProtocol) {
    locationLabel.text = vm.title
  }
}

fileprivate enum UIConstants {
  static let cornerRadius: CGFloat = 5.0
}
