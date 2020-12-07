//
//  PostingCommerceDigitalGoodLicensingTableViewCell.swift
//  Pibble
//
//  Created by Sergey Kazakov on 24/01/2019.
//  Copyright © 2019 com.kazai. All rights reserved.
//

import UIKit

class PostingCommerceDigitalGoodLicensingTableViewCell: UITableViewCell, DequeueableCell {
  @IBOutlet weak var containerView: UIView!
  
  @IBOutlet weak var commercialUseSwitch: UISwitch!
  @IBOutlet weak var editorialUseSwitch: UISwitch!
  @IBOutlet weak var royaltyFreeUseSwitch: UISwitch!
  @IBOutlet weak var exclusiveUseSwitch: UISwitch!
  
  
  @IBAction func commercialUseSwitchChangeAction(_ sender: UISwitch) {
    handler?(self, .commercialUseChanged(sender.isOn))
  }
  
  @IBAction func editorialUseSwitchChangeAction(_ sender: UISwitch) {
    handler?(self, .editorialUseChanged(sender.isOn))
  }
  
  @IBAction func royaltyFreeUseSwitchChangeAction(_ sender: UISwitch) {
    handler?(self, .royaltyFreeUseChanged(sender.isOn))
  }
  
  @IBAction func exclusiveUseSwitchChangeAction(_ sender: UISwitch) {
    handler?(self, .exclusiveUseChanged(sender.isOn))
  }
 
  fileprivate var handler: MediaPosting.PostingCommerceEditActionsHandler?
  
  
  func setViewModel(_ vm: MediaPostingDigitalGoodLicensingViewModelProtocol, handler: @escaping MediaPosting.PostingCommerceEditActionsHandler) {
    self.handler = handler
    commercialUseSwitch.isOn = vm.commercialUseAllowed
    editorialUseSwitch.isOn = vm.editorialUseAllowed
    royaltyFreeUseSwitch.isOn = vm.royaltyFreeUseAllowed
    exclusiveUseSwitch.isOn = vm.exclusiveUseAllowed
    
    containerView.layer.cornerRadius = 4.0
    containerView.clipsToBounds = true
  }
}
