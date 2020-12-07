//
//  PostingCommercePriceInputTableViewCell.swift
//  Pibble
//
//  Created by Sergey Kazakov on 25/01/2019.
//  Copyright © 2019 com.kazai. All rights reserved.
//

import UIKit

class PostingCommercePriceInputTableViewCell: UITableViewCell, DequeueableCell {
  @IBOutlet weak var containerView: UIView!
  
  @IBOutlet weak var titleTextField: UITextField!
  @IBOutlet weak var backgroundContainerView: UIView!
  
  @IBAction func titleEditingEndAction(_ sender: Any) {
    handler?(self, .priceEndEditing)
  }
  
  @IBAction func titleEditingChangedAction(_ sender: UITextField) {
    handler?(self, .priceChanged(sender.text ?? ""))
  }
  
  fileprivate var handler: MediaPosting.PostingCommerceEditActionsHandler?
  
  func setViewModel(_ vm: MediaPostingCommercePriceViewModelProtocol, handler: @escaping MediaPosting.PostingCommerceEditActionsHandler) {
    self.handler = handler
    titleTextField.text = vm.amount
    
    backgroundContainerView.layer.cornerRadius = 4.0
    backgroundContainerView.clipsToBounds = true
  }
  
  //  func setViewModel(_ vm: CampaignEditTitleViewModelProtocol, handler: @escaping CampaignEditTitleInputTableViewCellActionHandler) {
  //    self.handler = handler
  //    titleTextField.text = vm.title
  //    titleTextField.attributedPlaceholder = vm.attributedPlaceholder
  //    backgroundContainerView.layer.cornerRadius = 4.0
  //    backgroundContainerView.clipsToBounds = true
  //  }
}
