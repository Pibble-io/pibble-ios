//
//  FundingPostDetailCampaignFinishTableViewCell.swift
//  Pibble-iOS
//
//  Created by Sergey Kazakov on 07/09/2019.
//  Copyright © 2019 com.kazai. All rights reserved.
//

import UIKit

class FundingPostDetailCampaignFinishTableViewCell: UITableViewCell, DequeueableCell {
  @IBOutlet weak var iconImageView: UIImageView!
  @IBOutlet weak var heightConstraint: NSLayoutConstraint!
  @IBOutlet weak var messageLabel: UILabel!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    layer.shouldRasterize = true
    layer.rasterizationScale = UIScreen.main.scale
  }
  
  func setViewModel(_ vm: FundingPostDetailCampaignFinishViewModelProtocol) {
    iconImageView.image = vm.iconImage
    messageLabel.text = vm.message
    heightConstraint.constant = vm.isExtended ?
      UIConstants.Constraints.defaultHeight :
      UIConstants.Constraints.collapsedHeight
  }
}

fileprivate enum UIConstants {
  enum Constraints {
    static let collapsedHeight: CGFloat = 29
    static let defaultHeight: CGFloat = 150
  }
}
