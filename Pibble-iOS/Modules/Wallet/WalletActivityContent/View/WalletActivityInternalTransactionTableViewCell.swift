//
//  WalletActivityInternalTransactionTableViewCell.swift
//  Pibble
//
//  Created by Kazakov Sergey on 25.08.2018.
//  Copyright © 2018 com.kazai. All rights reserved.
//

import UIKit

class WalletActivityInternalTransactionTableViewCell: UITableViewCell, DequeueableCell {
  @IBOutlet weak var transactionTitleLabel: UILabel!
  @IBOutlet weak var transactionNoteLabel: UILabel!
  @IBOutlet weak var transactionValueLabel: UILabel!
  @IBOutlet weak var transactionDateLabel: UILabel!
  
  @IBOutlet weak var transactionUserpicImage: UIImageView!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }
  
  func setViewModel(_ vm: WalletActivityInternalTransactionViewModelProtocol) {
    transactionTitleLabel.attributedText = vm.transactionTitle
    transactionNoteLabel.text = vm.transactionNote
    transactionValueLabel.text = vm.transactionValue
    transactionDateLabel.text = vm.transactionDate
    transactionValueLabel.textColor = vm.currencyColor
    
    transactionUserpicImage.setCornersToCircle()
    transactionUserpicImage.image = vm.userpicPlaceholder
    transactionUserpicImage.setCachedImageOrDownload(vm.userpicUrlString)

  }
}

fileprivate enum UIConstants {
  enum Colors {
    static let outcoming = UIColor.pinkPibble
    static let incoming = UIColor.bluePibble
  }
}
