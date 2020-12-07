//
//  CampaignEditHeaderItemTableViewCell.swift
//  Pibble-iOS
//
//  Created by Sergey Kazakov on 02/09/2019.
//  Copyright © 2019 com.kazai. All rights reserved.
//

import UIKit

class CampaignEditHeaderItemTableViewCell: UITableViewCell, DequeueableCell {
  @IBOutlet weak var containerView: UIView!
  @IBOutlet weak var headerTitleLabel: UILabel!
  
  override func awakeFromNib() {
    super.awakeFromNib()
  }
  
  override func draw(_ rect: CGRect) {
    containerView.roundCorners([.topLeft, .topRight], radius: UIConstants.cornerRadius)
  }
  
  func setViewModel(_ vm: CampaignEditHeaderViewModelProtocol) {
    headerTitleLabel.text = vm.title
  }
}

fileprivate enum UIConstants {
  static let cornerRadius: CGFloat = 5.0
}
