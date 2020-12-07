//
//  OutcomingMessageTableViewCell.swift
//  Pibble
//
//  Created by Sergey Kazakov on 12/02/2019.
//  Copyright © 2019 com.kazai. All rights reserved.
//

import UIKit

class ChatOutcomingMessageTableViewCell: UITableViewCell, DequeueableCell {
  
  @IBOutlet weak var messageLabel: UILabel!
  @IBOutlet weak var dateLabel: UILabel!
  @IBOutlet weak var messageBackgroundView: UIView!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    layer.shouldRasterize = true
    layer.rasterizationScale = UIScreen.main.scale
    
    messageBackgroundView.layer.cornerRadius = UIConstants.backgroundCornerRadius
    messageBackgroundView.clipsToBounds = true
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }
  
  func setViewModel(_ vm: ChatTextMessageViewModelProtocol) {
    messageLabel.text = vm.messageText
    dateLabel.text = vm.date
  }
}

fileprivate enum UIConstants {
  static let backgroundCornerRadius: CGFloat = 25
}
