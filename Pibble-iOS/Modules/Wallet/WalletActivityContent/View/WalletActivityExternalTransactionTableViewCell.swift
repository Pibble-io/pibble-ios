//
//  WalletActivityExternalTransactionTableViewCell.swift
//  Pibble
//
//  Created by Kazakov Sergey on 25.08.2018.
//  Copyright © 2018 com.kazai. All rights reserved.
//

import UIKit

class WalletActivityExternalTransactionTableViewCell: UITableViewCell, DequeueableCell {
  @IBOutlet weak var transactionTitleLabel: UILabel!
  @IBOutlet weak var transactionNoteLabel: UILabel!
  @IBOutlet weak var transactionValueLabel: UILabel!
  @IBOutlet weak var transactionDateLabel: UILabel!
  
  @IBOutlet weak var transactionIdLabel: UILabel!
  
  @IBOutlet weak var copySuccessView: UIView!
  
  @IBOutlet weak var copySuccessBackgroundHighlightView: UIView!
  @IBAction func copyTransactionIdAction(_ sender: Any) {
    handler?(self, .copyTransactionId)
    copySuccessView.alpha = 1.0
    copySuccessBackgroundHighlightView.alpha = 1.0
    UIView.animate(withDuration: 0.3, delay: 0.15, options: .curveLinear, animations: { [weak self] in
      self?.copySuccessView.alpha = 0.0
      self?.copySuccessBackgroundHighlightView.alpha = 0.0
    }) { (_) in }
  }
  
  fileprivate var handler: WalletActivityContent.WalletActivityActionHandler?
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
    copySuccessView.alpha = 0.0
    copySuccessBackgroundHighlightView.alpha = 0.0
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }
  
  func setViewModel(_ vm: WalletActivityExtenalTransactionViewModelProtocol, handler: @escaping WalletActivityContent.WalletActivityActionHandler) {
    self.handler = handler
    transactionTitleLabel.text = vm.transactionTitle
    transactionNoteLabel.text = vm.transactionAddress
    transactionValueLabel.text = vm.transactionValue
    transactionDateLabel.text = vm.transactionDate
    transactionValueLabel.textColor = vm.currencyColor
    transactionIdLabel.text = vm.transactionId
  }
}

fileprivate enum UIConstants {
  enum Colors {
    static let outcoming = UIColor.pinkPibble
    static let incoming = UIColor.bluePibble
    
    static let transactionIdCopiedBackground = UIColor.black
    static let transactionIdBackground = UIColor.white
  }
}
