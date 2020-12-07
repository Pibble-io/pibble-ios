//
//  PostsFeedPromotedPostTableViewCell.swift
//  Pibble
//
//  Created by Kazakov Sergey on 06.12.2018.
//  Copyright © 2018 com.kazai. All rights reserved.
//

import UIKit

class PostsFeedPromotedPostTableViewCell: UITableViewCell, DequeueableCell {
  @IBOutlet weak var actionTitleLabel: UILabel!
  
  @IBOutlet weak var statusLabel: UILabel!
  
  
  fileprivate var handler: PostsFeed.PromotionActionsTableViewCellHandler?
  
  @IBAction func promoAction(_ sender: Any) {
    handler?(self, .showDestination)
  }
  
  @IBOutlet weak var promotionBackgroundView: UIView!
  override func awakeFromNib() {
    super.awakeFromNib()
    layer.shouldRasterize = true
    layer.rasterizationScale = UIScreen.main.scale
  }
  
  func setViewModel(_ vm: PostsFeedItemPromotionViewModelProtocol, handler: @escaping PostsFeed.PromotionActionsTableViewCellHandler) {
    self.handler = handler
    statusLabel.text = vm.statusTitle
    promotionBackgroundView.backgroundColor = vm.backgroundColor
    actionTitleLabel.text = vm.actionTitle
  }
}
