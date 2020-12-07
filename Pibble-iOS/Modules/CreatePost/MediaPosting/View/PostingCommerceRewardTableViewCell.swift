//
//  PostingCommerceRewardTableViewCell.swift
//  Pibble
//
//  Created by Sergey Kazakov on 27/01/2019.
//  Copyright © 2019 com.kazai. All rights reserved.
//

import UIKit

class PostingCommerceRewardTableViewCell: UITableViewCell, DequeueableCell {
  
  @IBOutlet weak var rewardAmountLabel: UILabel!
  @IBOutlet weak var backgroundContainerView: UIView!
  
  func setViewModel(_ vm: MediaPostingCommerceRewardViewModelProtocol) {
    rewardAmountLabel.text = vm.amount
    
    backgroundContainerView.layer.cornerRadius = 4.0
    backgroundContainerView.clipsToBounds = true
  }
}
