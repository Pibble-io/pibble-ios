//
//  CampaignEditExpandingSectionItemTableViewCell.swift
//  Pibble
//
//  Created by Kazakov Sergey on 24.10.2018.
//  Copyright © 2018 com.kazai. All rights reserved.
//

import UIKit

class CampaignEditExpandingSectionItemTableViewCell: UITableViewCell, DequeueableCell {
  @IBOutlet weak var itemTitleLabel: UILabel!
  @IBOutlet weak var backgroundContainerView: UIView!
  
  fileprivate var isItemSelected: Bool = false
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    guard !isItemSelected else {
      return
    }
    
    backgroundContainerView.backgroundColor = selected ?
      UIConstants.Colors.selectedBackground :
      UIConstants.Colors.deselectedBackground
    
    itemTitleLabel.textColor = selected ?
      UIConstants.Colors.selectedTitle :
      UIConstants.Colors.deselectedTitle
  }
  
  override func setHighlighted(_ highlighted: Bool, animated: Bool) {
    super.setHighlighted(highlighted, animated: animated)
    
    guard !isItemSelected else {
      return
    }
    
    backgroundContainerView.backgroundColor = highlighted ?
      UIConstants.Colors.selectedBackground :
      UIConstants.Colors.deselectedBackground
    
    itemTitleLabel.textColor = highlighted ?
      UIConstants.Colors.selectedTitle :
      UIConstants.Colors.deselectedTitle
    
  }
  
  func setViewModel(_ vm: CampaignEditSelectionPlainItemViewModelProtocol) {
    itemTitleLabel.text = vm.title
    
    backgroundContainerView.setCornersToCircleByHeight()
    backgroundContainerView.layer.borderWidth = 1.0
    backgroundContainerView.layer.borderColor = UIConstants.Colors.backgroundContainerBorder.cgColor
    
    itemTitleLabel.textColor = vm.isSelected ?
      UIConstants.Colors.selectedTitle :
      UIConstants.Colors.deselectedTitle
    
    backgroundContainerView.backgroundColor = vm.isSelected ?
      UIConstants.Colors.selectedBackground :
      UIConstants.Colors.deselectedBackground
    
    isItemSelected = vm.isSelected
    
  }
}

fileprivate enum UIConstants {
  enum Colors {
    static let backgroundContainerBorder = UIColor.gray191
    
    static let selectedTitle = UIColor.white
    static let deselectedTitle = UIColor.black
    
    static let selectedBackground = UIColor.bluePibble
    static let deselectedBackground = UIColor.gray227
    
    
  }
}
