//
//  UserProfileFollowActionsTableViewCell.swift
//  Pibble
//
//  Created by Kazakov Sergey on 06.11.2018.
//  Copyright © 2018 com.kazai. All rights reserved.
//

import UIKit

typealias UserProfileFollowActionsHandler = (UserProfileFollowActionsTableViewCell, UserProfileContent.FollowActions) -> Void
class UserProfileFollowActionsTableViewCell: UITableViewCell, DequeueableCell {
  @IBOutlet weak var leftButton: UIButton!
  @IBOutlet weak var rightButton: UIButton!
  @IBAction func rightButtonAction(_ sender: Any) {
    handler?(self, .friendship)
  }
  
  @IBAction func leftButtonAction(_ sender: Any) {
    handler?(self, .following)
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
    layer.shouldRasterize = true
    layer.rasterizationScale = UIScreen.main.scale
  }
  
  fileprivate var handler: UserProfileFollowActionsHandler?
  
  func setViewModel(_ vm: UserProfileFollowActionsViewModelProtocol, handler: @escaping UserProfileFollowActionsHandler) {
    self.handler = handler
    
    leftButton.layer.cornerRadius = UIConstants.buttonsCornerRadius
    rightButton.layer.cornerRadius = UIConstants.buttonsCornerRadius
    
    leftButton.clipsToBounds = true
    rightButton.clipsToBounds = true
    
    leftButton.layer.borderWidth = 1.0
    rightButton.layer.borderWidth = 1.0
    //add spaces to title because button width tend to equal title width for larger titles
    leftButton.setTitleForAllStates("  \(vm.leftActionTitle)  ")
    rightButton.setTitleForAllStates("  \(vm.rightActionTitle)  ")
    
    let leftHighlightedBorderColor = vm.isLeftActionPromoted ?
    UIConstants.Colors.promotedButtonBorder :
    UIConstants.Colors.highlightedButtonBorder
    
    let leftBorderColor = vm.isLeftActionHighlighted ?
      leftHighlightedBorderColor :
      UIConstants.Colors.unHighlightedButtonBorder
    
    let leftHighlightedTitleColor = vm.isLeftActionPromoted ?
      UIConstants.Colors.promotedButtonTitle :
      UIConstants.Colors.highlightedButtonTitle
    
    let leftTitleColor = vm.isLeftActionHighlighted ?
      leftHighlightedTitleColor :
      UIConstants.Colors.unHighlightedButtonTitle
    
    leftButton.layer.borderColor = leftBorderColor.cgColor
    leftButton.setTitleColor(leftTitleColor, for: .normal)
    
    let rightHighlightedBorderColor = vm.isRightActionPromoted ?
      UIConstants.Colors.promotedButtonBorder :
      UIConstants.Colors.highlightedButtonBorder
    
    let rightBorderColor = vm.isRightActionHighlighted ?
      rightHighlightedBorderColor :
      UIConstants.Colors.unHighlightedButtonBorder
    
    let rightHighlightedTitleColor = vm.isRightActionPromoted ?
      UIConstants.Colors.promotedButtonTitle :
      UIConstants.Colors.highlightedButtonTitle
    
    let rightTitleColor = vm.isRightActionHighlighted ?
      rightHighlightedTitleColor :
      UIConstants.Colors.unHighlightedButtonTitle
    
    rightButton.layer.borderColor = rightBorderColor.cgColor
    rightButton.setTitleColor(rightTitleColor, for: .normal)
  }
}

fileprivate enum UIConstants {
  static let buttonsCornerRadius: CGFloat = 7.0
  
  enum Colors {
    static let highlightedButtonTitle = UIColor.bluePibble
    static let unHighlightedButtonTitle = UIColor.black
    
    static let highlightedButtonBorder = UIColor.bluePibble
    static let unHighlightedButtonBorder = UIColor.gray213
    
    static let promotedButtonTitle = UIColor.pinkPibble
    static let promotedButtonBorder = UIColor.pinkPibble
  }
}
