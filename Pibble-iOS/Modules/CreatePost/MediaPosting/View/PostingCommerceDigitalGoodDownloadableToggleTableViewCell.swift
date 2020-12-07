//
//  PostingCommerceDigitalGoodDownloadableToggleTableViewCell.swift
//  Pibble
//
//  Created by Sergey Kazakov on 01/05/2019.
//  Copyright © 2019 com.kazai. All rights reserved.
//

import UIKit

class PostingCommerceDigitalGoodDownloadableToggleTableViewCell: UITableViewCell, DequeueableCell {
  
  @IBOutlet weak var containerView: UIView!
  
  @IBOutlet weak var digitalGoodSwitch: UISwitch!
  
  @IBAction func digitalGoodSwitchChangeAction(_ sender: UISwitch) {
    handler?(self, .isDownloadableChanged(sender.isOn))
  }
  
  fileprivate var handler: MediaPosting.PostingCommerceEditActionsHandler?
  
  func setViewModel(_ vm: MediaPostingDigitalGoodDownloadableToggleViewModelProtocol, handler: @escaping MediaPosting.PostingCommerceEditActionsHandler) {
    self.handler = handler
    
    digitalGoodSwitch.isOn = vm.isSelected
    
    containerView.layer.cornerRadius = 4.0
    containerView.clipsToBounds = true
  }
}
