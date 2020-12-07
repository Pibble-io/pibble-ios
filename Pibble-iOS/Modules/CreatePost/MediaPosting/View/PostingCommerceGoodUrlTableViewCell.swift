//
//  PostingCommerceGoodUrlTableViewCell.swift
//  Pibble
//
//  Created by Sergey Kazakov on 30/06/2019.
//  Copyright © 2019 com.kazai. All rights reserved.
//

import UIKit

class PostingCommerceGoodUrlInputTableViewCell: UITableViewCell, DequeueableCell {
  
  @IBOutlet weak var urlInputTextField: UITextField!
  @IBOutlet weak var urlValidationImage: UIImageView!
  
  
  @IBOutlet weak var backgroundContainerView: UIView!
  
  @IBAction func titleEditingEndAction(_ sender: Any) {
    handler?(self, .goodsUrlEndEditing)
  }
  
  @IBAction func titleEditingChangedAction(_ sender: UITextField) {
    handler?(self, .goodsUrlChanged(sender.text ?? ""))
  }
  
  fileprivate var handler: MediaPosting.PostingCommerceEditActionsHandler?
  
  func setViewModel(_ vm: MediaPostingGoodUrlViewModelProtocol, handler: @escaping MediaPosting.PostingCommerceEditActionsHandler) {
    self.handler = handler
    urlInputTextField.text = vm.urlString
    urlValidationImage.isHidden = !vm.shouldPresentUrlValidationImage
    urlValidationImage.image = vm.urlStringValidationImage
    
    backgroundContainerView.layer.cornerRadius = 4.0
    backgroundContainerView.clipsToBounds = true
  }
}
