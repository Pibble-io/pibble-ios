//
//  PostsFeedCommercialPostTitleTableViewCell.swift
//  Pibble
//
//  Created by Sergey Kazakov on 02/02/2019.
//  Copyright © 2019 com.kazai. All rights reserved.
//

import UIKit

class PostsFeedCommercialPostTitleTableViewCell: UITableViewCell, DequeueableCell {
  
  @IBOutlet weak var commercialPostPrice: UILabel!
  
  @IBOutlet weak var rewardTitleLabel: UILabel!
  
  @IBOutlet weak var rewardAmountLabel: UILabel!
  
  @IBOutlet weak var statusLabel: UILabel!
  @IBOutlet weak var chatButton: UIButton!
  
  @IBAction func chatAction(_ sender: Any) {
    handler?(self, .chat)
  }
  
  @IBAction func selectItemAction(_ sender: Any) {
    handler?(self, .detail)
  }
  
  fileprivate var handler: PostsFeed.CommercialPostActionsHandler?
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }
  
  func setViewModel(_ vm: PostsFeedCommercialInfoViewModelProtocol, handler: @escaping PostsFeed.CommercialPostActionsHandler) {
    self.handler = handler
   
    commercialPostPrice.text = vm.commercialPostPrice
    
    rewardAmountLabel.text = vm.rewardAmountLabel
    
    rewardTitleLabel.isHidden = vm.isStatusEnabled
    rewardAmountLabel.isHidden = vm.isStatusEnabled
    chatButton.isHidden = vm.isStatusEnabled
    
    statusLabel.isHidden = !vm.isStatusEnabled
    statusLabel.text = vm.status
    
  }
}

