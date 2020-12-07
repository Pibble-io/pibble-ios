//
//  PostingCommerceGoodsEscrowTermsTableVIewCell.swift
//  Pibble
//
//  Created by Sergey Kazakov on 30/06/2019.
//  Copyright © 2019 com.kazai. All rights reserved.
//

import UIKit

class PostingCommerceGoodsEscrowTermsTableVIewCell: UITableViewCell, DequeueableCell {
  @IBOutlet weak var containerView: UIView!
  
  @IBOutlet weak var checkBoxButton: UIButton!
  
  @IBAction func checkBoxSelectionChangeAction(_ sender: UIButton) {
    sender.isSelected = !sender.isSelected
    handler?(self, .userAgreeToTermsOfGoodsEscrowChanged(sender.isSelected))
  }
  
  fileprivate var handler: MediaPosting.PostingCommerceEditActionsHandler?
  
  func setViewModel(_ vm: MediaPostingGoodsEscrowAgreementViewModelProtocol, handler: @escaping MediaPosting.PostingCommerceEditActionsHandler) {
    self.handler = handler
    checkBoxButton.isSelected = vm.hasUserAgreedToTerms
    
    containerView.layer.cornerRadius = 4.0
    containerView.clipsToBounds = true
  }
}
