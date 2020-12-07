//
//  WalletActivityDonatorTableViewCell.swift
//  Pibble-iOS
//
//  Created by Sergey Kazakov on 12/09/2019.
//  Copyright © 2019 com.kazai. All rights reserved.
//

import UIKit

class WalletActivityDonatorTableViewCell: UITableViewCell, DequeueableCell {
  
  @IBOutlet weak var userImageView: UIImageView!
  
  @IBOutlet weak var usernameLabel: UILabel!
  @IBOutlet weak var priceTitleLabel: UILabel!
  
  @IBOutlet weak var amountLabel: UILabel!
  @IBOutlet weak var userLevelLabel: UILabel!
  
  @IBAction func userpicAction(_ sender: Any) {
    handler?(self, .showUserProfile)
  }
  
  fileprivate var handler: WalletActivityContent.WalletActivityActionHandler?
  
  func setViewModel(_ vm: WalletActivityDonatorTransactionViewModelProtocol, handler: @escaping WalletActivityContent.WalletActivityActionHandler) {
    self.handler = handler
    
    userImageView.setCornersToCircle()
    userImageView.image = vm.avatarPlaceholder
    userImageView.setCachedImageOrDownload(vm.avatarURLString)
    usernameLabel.text = vm.username
    userLevelLabel.text = vm.userLevel
    
    amountLabel.text = vm.amount
    priceTitleLabel.text = vm.priceTitle
  }
}

fileprivate enum UIConstants {
  static let buttonsCornerRadius: CGFloat = 7.0
  
  enum Colors {
    static let highlightedButtonTitle = UIColor.bluePibble
    static let unHighlightedButtonTitle = UIColor.black
    
    static let highlightedButtonBorder = UIColor.bluePibble
    static let unHighlightedButtonBorder = UIColor.gray213
  }
}
