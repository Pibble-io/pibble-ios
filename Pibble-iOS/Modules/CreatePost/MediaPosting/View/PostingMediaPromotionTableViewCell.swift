//
//  PostingMediaPromotionTableViewCell.swift
//  Pibble
//
//  Created by Kazakov Sergey on 16.07.2018.
//  Copyright © 2018 com.kazai. All rights reserved.
//

import UIKit

class PostingMediaPromotionTableViewCell: UITableViewCell, DequeueableCell {
  @IBOutlet weak var containerView: UIView!
  @IBOutlet weak var promotionLabel: UILabel!
  @IBOutlet weak var promotionBudgetLabel: UILabel!
  
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
  
  func setViewModel(_ vm: MediaPostingPromotionViewModelProtocol) {
    promotionLabel.text = vm.title
    promotionBudgetLabel.text = vm.promotionBudget
  }
  
  func setViewModel(_ vm: MediaPostingCampaignViewModelProtocol) {
    promotionLabel.text = vm.title
    promotionBudgetLabel.text = ""
    promotionLabel.textColor = vm.isSelected ? UIConstants.Colors.picked : UIConstants.Colors.notPicked
  }
}

fileprivate enum UIConstants {
  static let cornerRadius: CGFloat = 5.0
  enum Colors {
    static let picked = UIColor.black
    static let notPicked = UIColor.gray168
  }
}
