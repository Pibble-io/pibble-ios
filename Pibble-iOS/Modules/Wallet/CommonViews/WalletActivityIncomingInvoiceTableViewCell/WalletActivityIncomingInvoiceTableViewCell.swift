//
//  WalletActivityReceiveRequestTableViewCell.swift
//  Pibble
//
//  Created by Kazakov Sergey on 24.08.2018.
//  Copyright © 2018 com.kazai. All rights reserved.
//

import UIKit

typealias WalletActivityIncomingInvoiceHandler = (WalletActivityIncomingInvoiceTableViewCell, Wallet.WalletActivityInvoiceAction) -> Void

class WalletActivityIncomingInvoiceTableViewCell: UITableViewCell, DequeueableCell {
  @IBOutlet weak var userpicImageView: UIImageView!
  @IBOutlet weak var invoiceTitleLabel: UILabel!
  @IBOutlet weak var invoiceNoteLabel: UILabel!
  @IBOutlet weak var invoiceValueLabel: UILabel!
  
  @IBOutlet weak var invoiceContentBackgroundView: UIView!
  @IBOutlet weak var invoiceCancelButton: UIButton!
  @IBOutlet weak var invoiceConfirmButton: UIButton!
  
  @IBOutlet weak var buttonsBackgroundViewHeightConstraint: NSLayoutConstraint!
  @IBOutlet weak var buttonsBackgroundViewTopContraint: NSLayoutConstraint!
  
  @IBAction func cancelAction(_ sender: Any) {
    handler?(self, .cancel)
  }
  
  @IBAction func confirmAction(_ sender: Any) {
     handler?(self, .confirm)
  }
  
  fileprivate var handler: WalletActivityIncomingInvoiceHandler?
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }
  
  func setViewModel(_ vm: WalletActivityInvoiceViewModelProtocol, handler: @escaping WalletActivityIncomingInvoiceHandler) {
    self.handler = handler
    
    invoiceContentBackgroundView.layer.cornerRadius = UIConstants.invoiceContentBackgroundViewCornerRadius
    
    invoiceConfirmButton.layer.cornerRadius =  UIConstants.Constraints.buttonsBackgroundMaxHeight * 0.5
    invoiceConfirmButton.clipsToBounds = true
    
    invoiceCancelButton.layer.cornerRadius =  UIConstants.Constraints.buttonsBackgroundMaxHeight * 0.5
    invoiceCancelButton.clipsToBounds = true
    invoiceCancelButton.layer.borderWidth = 1.0
    invoiceCancelButton.layer.borderColor = UIConstants.Colors.cancelButtonBorder.cgColor
    
    userpicImageView.image = vm.userpicPlacholder
    userpicImageView.setCachedImageOrDownload(vm.userpicUrlString)
    userpicImageView.setCornersToCircle()
    
    invoiceTitleLabel.attributedText = vm.invoiceTitle
    invoiceNoteLabel.text = vm.invoiceNote
    invoiceValueLabel.text = vm.invoiceValue
    
    invoiceValueLabel.textColor = vm.currencyColor
    
    buttonsBackgroundViewHeightConstraint.constant = vm.shouldPresentActions ? UIConstants.Constraints.buttonsBackgroundMaxHeight :
      UIConstants.Constraints.buttonsBackgroundMinHeight
    
    buttonsBackgroundViewTopContraint.constant = vm.shouldPresentActions ? UIConstants.Constraints.buttonsBackgroundTopMax :
      UIConstants.Constraints.buttonsBackgroundTopMin
  }
}

fileprivate enum UIConstants {
  enum Colors {
    static let cancelButtonBorder = UIColor.gray191
    static let incoming = UIColor.pinkPibble
    static let outcoming = UIColor.bluePibble
  }
  
  enum Constraints {
    static let buttonsBackgroundMaxHeight: CGFloat = 28.0
    static let buttonsBackgroundMinHeight: CGFloat = 0.0
    
    static let buttonsBackgroundTopMax: CGFloat = 15.0
    static let buttonsBackgroundTopMin: CGFloat = 0.0
  }
  
  static let invoiceContentBackgroundViewCornerRadius: CGFloat = 5.0
}
