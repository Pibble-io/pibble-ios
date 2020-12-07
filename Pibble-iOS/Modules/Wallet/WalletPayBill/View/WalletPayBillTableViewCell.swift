//
//  WalletPayBillTableViewCell.swift
//  Pibble
//
//  Created by Kazakov Sergey on 28.08.2018.
//  Copyright © 2018 com.kazai. All rights reserved.
//

import UIKit

class WalletPayBillTableViewCell: UITableViewCell, DequeueableCell {
  
  @IBOutlet weak var invoiceItemImageView: UIImageView!
  @IBOutlet weak var invoiceDescriptionLabel: UILabel!
  @IBOutlet weak var invoiceValueLabel: UILabel!
  
  @IBOutlet weak var backgroundContainerView: UIView!
  
  @IBOutlet weak var confirmButton: UIButton!
  @IBOutlet weak var cancelButton: UIButton!
  
  @IBOutlet weak var dateLabel: UILabel!
  @IBAction func cancelAction(_ sender: Any) {
  }
  
  @IBAction func confirmAction(_ sender: Any) {
  }
  
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
    
    confirmButton.layer.cornerRadius = confirmButton.bounds.height * 0.5
    confirmButton.clipsToBounds = true
    
    cancelButton.layer.cornerRadius = confirmButton.bounds.height * 0.5
    cancelButton.clipsToBounds = true
    cancelButton.layer.borderWidth = 1.0
    cancelButton.layer.borderColor = UIConstants.Colors.cancelButtonBorder.cgColor
    
    backgroundContainerView.layer.cornerRadius = UIConstants.containerViewCornerRadius
    backgroundContainerView.clipsToBounds = true
    
    invoiceItemImageView.layer.cornerRadius = UIConstants.invoiceItemViewCornerRadius
    invoiceItemImageView.clipsToBounds = true
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }
}


fileprivate enum UIConstants {
  static let containerViewCornerRadius: CGFloat = 5.0
  static let invoiceItemViewCornerRadius: CGFloat = 5.0
  
  enum Colors {
    static let cancelButtonBorder = UIColor.gray191
  }
  
}
