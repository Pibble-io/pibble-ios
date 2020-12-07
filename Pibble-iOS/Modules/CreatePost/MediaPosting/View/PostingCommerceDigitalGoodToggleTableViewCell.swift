//
//  PostingCommerceDigitalGoodToggleTableViewCell.swift
//  Pibble
//
//  Created by Sergey Kazakov on 24/01/2019.
//  Copyright © 2019 com.kazai. All rights reserved.
//

import UIKit

class PostingCommerceDigitalGoodToggleTableViewCell: UITableViewCell, DequeueableCell {
  
  @IBOutlet weak var containerView: UIView!
  
  @IBOutlet weak var digitalGoodSwitch: UISwitch!
  
  @IBAction func digitalGoodSwitchChangeAction(_ sender: UISwitch) {
    handler?(self, .digitalGoodToggleChanged(sender.isOn))
  }
  
  fileprivate var handler: MediaPosting.PostingCommerceEditActionsHandler?
  
  func setViewModel(_ vm: MediaPostingDigitalGoodToggleViewModelProtocol, handler: @escaping MediaPosting.PostingCommerceEditActionsHandler) {
    self.handler = handler
    
    digitalGoodSwitch.isOn = vm.isSelected
    
    containerView.layer.cornerRadius = 4.0
    containerView.clipsToBounds = true
  }
}
