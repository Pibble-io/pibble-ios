//
//  FundingPostDetailActionButtonTableViewCell.swift
//  Pibble-iOS
//
//  Created by Sergey Kazakov on 08/09/2019.
//  Copyright © 2019 com.kazai. All rights reserved.
//

import UIKit

class FundingPostDetailActionButtonTableViewCell: UITableViewCell, DequeueableCell {
  @IBOutlet weak var checkoutButton: UIButton!
  
  fileprivate var handler: FundingPostDetail.ActionHandler?
  fileprivate var action: FundingPostDetail.Actions?
  
  @IBAction func checkoutAction(_ sender: UIButton) {
    guard let action = action else {
      return
    }
    
    handler?(self, action)
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
    checkoutButton.layer.cornerRadius = UIConstants.CornerRadius.button
    checkoutButton.clipsToBounds = true
  }
  
  func setViewModel(_ vm: FundingPostDetailActionButtonViewModelProtocol, handler: @escaping FundingPostDetail.ActionHandler) {
    checkoutButton.setTitleForAllStates(vm.title)
    action = vm.action
    self.handler = handler
  }
}

fileprivate enum UIConstants {
  enum CornerRadius {
    static let button: CGFloat = 4.0
  }
}
