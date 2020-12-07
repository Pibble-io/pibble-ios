//
//  PostingCommerceGoodIsNewToggleTableViewCell.swift
//  Pibble
//
//  Created by Sergey Kazakov on 30/06/2019.
//  Copyright © 2019 com.kazai. All rights reserved.
//

import UIKit

class PostingCommerceGoodIsNewToggleTableViewCell: UITableViewCell, DequeueableCell {
  @IBOutlet weak var containerView: UIView!
  @IBOutlet weak var isUsedButton: UIButton!
  @IBOutlet weak var isNewButton: UIButton!
  
  @IBAction func isNewSelectAction(_ sender: Any) {
    isNewButton.isSelected = true
    isUsedButton.isSelected = false
    
    handler?(self, .isNewGoodChanged(true))
  }
 
  @IBAction func isUsedSelectAction(_ sender: Any) {
    isNewButton.isSelected = false
    isUsedButton.isSelected = true
    
    handler?(self, .isNewGoodChanged(false))
  }
 
  fileprivate var handler: MediaPosting.PostingCommerceEditActionsHandler?
  
  func setViewModel(_ vm: MediaPostingGoodIsNewToggleViewModelProtocol, handler: @escaping MediaPosting.PostingCommerceEditActionsHandler) {
    self.handler = handler
    
    containerView.layer.cornerRadius = 4.0
    containerView.clipsToBounds = true
    
    isNewButton.isSelected = vm.isSelected
    isUsedButton.isSelected = !vm.isSelected
  }
}
