//
//  CommercialPostDetailCheckoutTableViewCell.swift
//  Pibble
//
//  Created by Sergey Kazakov on 07/02/2019.
//  Copyright © 2019 com.kazai. All rights reserved.
//

import UIKit

class CommercialPostDetailCheckoutTableViewCell: UITableViewCell, DequeueableCell {
  @IBOutlet weak var checkoutButton: UIButton!
  
  @IBOutlet weak var checkoutInfoLabel: UILabel!
  
  fileprivate var handler: CommercialPostDetail.ActionHandler?
  
  @IBAction func checkoutAction(_ sender: UIButton) {
    sender.isEnabled = false
    checkoutButton.backgroundColor = UIConstants.Colors.checkoutButtonBackgroundDisabled
    handler?(self, .checkout)
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
    checkoutButton.layer.cornerRadius = UIConstants.CornerRadius.button
    checkoutButton.clipsToBounds = true
  }
  
  func setViewModel(_ vm: CommercialPostCheckoutButtonViewModelProtocol, handler: @escaping CommercialPostDetail.ActionHandler) {
    checkoutButton.backgroundColor = vm.isEnabled ?
      UIConstants.Colors.checkoutButtonBackground:
      UIConstants.Colors.checkoutButtonBackgroundDisabled
    
    checkoutButton.isEnabled = vm.isEnabled
    checkoutButton.setTitleForAllStates(vm.title)
    checkoutButton.setTitle(vm.disabledStateTitle, for: .disabled)
    
    self.handler = handler
  }
}

fileprivate enum UIConstants {
  enum CornerRadius {
    static let button: CGFloat = 4.0
  }
  
  enum Colors {
    static let checkoutButtonBackground = UIColor.bluePibble
    static let checkoutButtonBackgroundDisabled = UIColor.gray191
  }
}
