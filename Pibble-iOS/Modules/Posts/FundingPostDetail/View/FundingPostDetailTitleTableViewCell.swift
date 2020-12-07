//
//  FundingPostDetailTitleTableViewCell.swift
//  Pibble-iOS
//
//  Created by Sergey Kazakov on 07/09/2019.
//  Copyright © 2019 com.kazai. All rights reserved.
//

import UIKit

class FundingPostDetailTitleTableViewCell: UITableViewCell, DequeueableCell {
  @IBOutlet weak var titleLabel: UILabel!
  
  @IBOutlet weak var priceAmountLabel: UILabel!
  
  @IBOutlet weak var iconImageView: UIImageView!
  
  @IBOutlet weak var containerView: UIView!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    containerView.clipsToBounds = true
    containerView.layer.cornerRadius = UIConstants.CornerRadius.contentView
  }
  
  func setViewModel(_ vm: FundingPostDetailTitleViewModelProtocol) {
    titleLabel.text = vm.title
    priceAmountLabel.text = vm.tags
    iconImageView.image = vm.icon
  }
}

fileprivate enum UIConstants {
  enum CornerRadius {
    static let contentView: CGFloat = 12.0
  }
}
