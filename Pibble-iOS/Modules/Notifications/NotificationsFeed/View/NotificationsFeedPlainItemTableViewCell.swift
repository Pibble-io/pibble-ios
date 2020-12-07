//
//  NotificationsFeedPlainItemTableViewCell.swift
//  Pibble
//
//  Created by Sergey Kazakov on 27/06/2019.
//  Copyright © 2019 com.kazai. All rights reserved.
//

import UIKit

class NotificationsFeedPlainItemTableViewCell: UITableViewCell, DequeueableCell {
  @IBOutlet weak var userImageView: UIImageView!
  @IBOutlet weak var messageLabel: UILabel!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    layer.shouldRasterize = true
    layer.rasterizationScale = UIScreen.main.scale
  }
  
  func setViewModel(_ vm: NotificationsFeedPlainItemViewModelProtocol) {
    userImageView.setCornersToCircle()
    userImageView.image = vm.avatarPlaceholder
    userImageView.setCachedImageOrDownload(vm.avatarURLString)
    messageLabel.attributedText = vm.attributedMessage
  }
  
}

fileprivate enum UIConstants {
  static let buttonsCornerRadius: CGFloat = 4.0
  
  enum Colors {
    static let highlightedButtonTitle = UIColor.bluePibble
    static let unHighlightedButtonTitle = UIColor.black
    
    static let highlightedButtonBorder = UIColor.bluePibble
    static let unHighlightedButtonBorder = UIColor.gray213
  }
}

