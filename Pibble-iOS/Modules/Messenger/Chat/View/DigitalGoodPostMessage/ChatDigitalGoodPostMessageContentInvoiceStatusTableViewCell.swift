//
//  ChatDigitalGoodPostMessageContentInvoiceStatusTableViewCell.swift
//  Pibble
//
//  Created by Sergey Kazakov on 22/02/2019.
//  Copyright © 2019 com.kazai. All rights reserved.
//

import UIKit

class ChatDigitalGoodPostMessageContentInvoiceStatusTableViewCell: UITableViewCell, DequeueableCell {
  @IBOutlet weak var checkoutStatusLabel: UILabel!
  @IBOutlet weak var checkoutStatusDescriptionLabel: UILabel!
  @IBOutlet weak var postAuthorImageView: UIImageView!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    postAuthorImageView.setCornersToCircle()
    layer.shouldRasterize = true
    layer.rasterizationScale = UIScreen.main.scale
  }
 
  func setViewModel(_ vm: ChatDigitalGoodPostMessageInvoiceStatusViewModelProtocol) {
    postAuthorImageView.image = vm.userpicPlaceholder
    postAuthorImageView.setCachedImageOrDownload(vm.userpicUrlString)
    
    checkoutStatusLabel.text = vm.checkoutStatus
    checkoutStatusDescriptionLabel.text = vm.checkoutStatusDescription
  }
}
