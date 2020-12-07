//
//  CampaignEditRewardTypeTableViewCell.swift
//  Pibble-iOS
//
//  Created by Sergey Kazakov on 02/09/2019.
//  Copyright © 2019 com.kazai. All rights reserved.
//

import UIKit

class CampaignEditSelectionItemTableViewCell: UITableViewCell, DequeueableCell {
  //static let identifier = "PostingMediaPromotionTableViewCell"
  
  @IBOutlet weak var containerView: UIView!
  @IBOutlet weak var itemTitleLabel: UILabel!
  @IBOutlet weak var itemSubtitleLabel: UILabel!
  @IBOutlet weak var selectionImageView: UIImageView!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
    
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }
  
  func setViewModel(_ vm: CampaignEditSelectionItemViewModelProtocol) {
    itemTitleLabel.text = vm.title
    itemSubtitleLabel.text = vm.subtitle
    
    selectionImageView.image = vm.isSelected ?
      UIImage(imageLiteralResourceName: "CampaignEdit-RoundedCheckBox-selected"):
      UIImage(imageLiteralResourceName: "CampaignEdit-RoundedCheckBox")
  }
}

fileprivate enum UIConstants {
  static let cornerRadius: CGFloat = 5.0
  enum Colors {
    static let picked = UIColor.black
    static let notPicked = UIColor.gray168
  }
}
