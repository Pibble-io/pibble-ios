//
//  WalletActivityOutcomingInvoiceTableViewCell.swift
//  Pibble
//
//  Created by Kazakov Sergey on 26.08.2018.
//  Copyright © 2018 com.kazai. All rights reserved.
//

import UIKit

class WalletActivityOutcomingInvoiceTableViewCell: UITableViewCell, DequeueableCell {
  
  @IBOutlet weak var invoiceTitleLabel: UILabel!
  @IBOutlet weak var invoiceNoteLabel: UILabel!
  @IBOutlet weak var invoiceValueLabel: UILabel!
  @IBOutlet weak var invoiceDateLabel: UILabel!
  
  @IBOutlet weak var invoiceUserpicImage: UIImageView!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }
  
  func setViewModel(_ vm: WalletActivityInvoiceViewModelProtocol) {
    invoiceTitleLabel.attributedText = vm.invoiceTitle
    invoiceNoteLabel.text = vm.invoiceNote
    invoiceValueLabel.text = vm.invoiceValue
    invoiceDateLabel.text = vm.invoiceDate
    
    invoiceValueLabel.textColor = vm.currencyColor
    
    invoiceUserpicImage.setCornersToCircle()
    invoiceUserpicImage.image = vm.userpicPlacholder
    invoiceUserpicImage.setCachedImageOrDownload(vm.userpicUrlString)
  }
}

fileprivate enum UIConstants {
  enum Colors {
    static let outcoming = UIColor.pinkPibble
    static let incoming = UIColor.bluePibble
  }
}
