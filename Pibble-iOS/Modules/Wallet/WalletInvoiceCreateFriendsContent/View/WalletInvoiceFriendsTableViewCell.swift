//
//  WalletInvoiceFriendsTableViewCell.swift
//  Pibble
//
//  Created by Kazakov Sergey on 01.09.2018.
//  Copyright © 2018 com.kazai. All rights reserved.
//

import UIKit

class WalletInvoiceFriendsTableViewCell: UITableViewCell, DequeueableCell {
  @IBOutlet weak var userpicImageView: UIImageView!
  @IBOutlet weak var usernameLabel: UILabel!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
    userpicImageView.setCornersToCircle()
    let bgColorView = UIView()
    bgColorView.backgroundColor = UIColor.gray227
    selectedBackgroundView = bgColorView
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }
  
  func setViewModel(_ vm: WalletInvoiceCreateFriendViewModelProtocol) {
    usernameLabel.text = vm.username
    userpicImageView.image = vm.userpicPlaceholder
    userpicImageView.setCachedImageOrDownload(vm.userpic)
  }
}
