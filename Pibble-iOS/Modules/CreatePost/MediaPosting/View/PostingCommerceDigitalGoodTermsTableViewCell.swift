//
//  PostingCommerceDigitalGoodTermsTableViewCell.swift
//  Pibble
//
//  Created by Sergey Kazakov on 25/01/2019.
//  Copyright © 2019 com.kazai. All rights reserved.
//

import UIKit

class PostingCommerceDigitalGoodTermsTableViewCell: UITableViewCell, DequeueableCell {
  @IBOutlet weak var containerView: UIView!
  
  @IBOutlet weak var responsibilityAgreementButton: UIButton!
  
  @IBAction func responsibilityAgreementChangeAction(_ sender: UIButton) {
    sender.isSelected = !sender.isSelected
    handler?(self, .userAgreeToTermsOfResponsibilityChanged(sender.isSelected))
  }
  
  fileprivate var handler: MediaPosting.PostingCommerceEditActionsHandler?  
  
  func setViewModel(_ vm: MediaPostingDigitalGoodAgreementViewModelProtocol, handler: @escaping MediaPosting.PostingCommerceEditActionsHandler) {
    self.handler = handler
    responsibilityAgreementButton.isSelected = vm.hasUserAgreedToTermsOfResponsibility
    
    containerView.layer.cornerRadius = 4.0
    containerView.clipsToBounds = true
  }
}
