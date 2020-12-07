//
//  PostingMediaDescriptionTableViewCell.swift
//  Pibble
//
//  Created by Kazakov Sergey on 16.07.2018.
//  Copyright © 2018 com.kazai. All rights reserved.
//

import UIKit

class PostingMediaDescriptionTableViewCell: UITableViewCell {
  static let identifier = "PostingMediaDescriptionTableViewCell"
  
  @IBOutlet weak var descriptionLabel: UILabel!
  
  @IBOutlet weak var containerView: UIView!
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
  
  func setViewModel(_ vm: MediaPostingDesctiptionViewModelProtocol) {
    descriptionLabel.text = vm.title
  }
}

fileprivate enum UIConstants {
  static let cornerRadius: CGFloat = 5.0
  
}
