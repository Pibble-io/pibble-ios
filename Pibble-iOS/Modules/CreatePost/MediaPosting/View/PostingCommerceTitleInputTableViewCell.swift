//
//  PostingCommerceTitleInputTableViewCell.swift
//  Pibble
//
//  Created by Sergey Kazakov on 25/01/2019.
//  Copyright © 2019 com.kazai. All rights reserved.
//

import UIKit

class PostingCommerceTitleInputTableViewCell: UITableViewCell, DequeueableCell {
  
  @IBOutlet weak var titleTextField: UITextField!
  @IBOutlet weak var backgroundContainerView: UIView!
  
  @IBAction func titleEditingEndAction(_ sender: Any) {
    handler?(self, .titleEndEditing)
  }
  
  @IBAction func titleEditingChangedAction(_ sender: UITextField) {
    handler?(self, .titleChanged(sender.text ?? ""))
  }
  
  fileprivate var handler: MediaPosting.PostingCommerceEditActionsHandler?
  
  func setViewModel(_ vm: MediaPostingCommerceTitleViewModelProtocol, handler: @escaping MediaPosting.PostingCommerceEditActionsHandler) {
    self.handler = handler
    titleTextField.text = vm.title
    
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
