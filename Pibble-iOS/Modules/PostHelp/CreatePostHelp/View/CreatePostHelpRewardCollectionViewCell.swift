//
//  CreatePostHelpRewardCollectionViewCell.swift
//  Pibble-iOS
//
//  Created by Sergey Kazakov on 27/09/2019.
//  Copyright © 2019 com.kazai. All rights reserved.
//

import UIKit

class CreatePostHelpRewardCollectionViewCell: UICollectionViewCell, DequeueableCell {
  
  @IBOutlet weak var containerView: UIView!
  
  @IBOutlet weak var amountLabel: UILabel!
  
  func setViewModel(_ vm: CreatePostHelpRewardItemViewModelProtocol) {
    containerView.backgroundColor = vm.isSelected ?
      UIConstants.Colors.selectedBackground:
      UIConstants.Colors.deselectedBackground
    
    amountLabel.text = vm.amount
    amountLabel.textColor = vm.isSelected ?
      UIConstants.Colors.selectedText:
      UIConstants.Colors.deselectedText
    
    containerView.setCornersToCircleByHeight()
  }
}

fileprivate enum UIConstants {
  enum Colors {
    static let deselectedBackground = UIColor.gray240
    static let selectedBackground = UIColor.bluePibble
    
    static let deselectedText = UIColor.black
    static let selectedText = UIColor.white
  }
}
