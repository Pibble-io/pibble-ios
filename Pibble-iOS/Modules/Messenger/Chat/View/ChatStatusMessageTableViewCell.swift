//
//  PaymentStatusMessageTableViewCell.swift
//  Pibble
//
//  Created by Sergey Kazakov on 16/02/2019.
//  Copyright © 2019 com.kazai. All rights reserved.
//

import UIKit

class ChatStatusMessageTableViewCell: UITableViewCell, DequeueableCell {
  @IBOutlet weak var messageLabel: UILabel!
  @IBOutlet weak var dateLabel: UILabel!
  @IBOutlet weak var messageBackgroundView: UIView!
  
  @IBOutlet weak var actionButton: UIButton!
  
  @IBOutlet weak var actionButtonHeightConstraint: NSLayoutConstraint!
  @IBOutlet var actionButtonTopConstraint: NSLayoutConstraint!
  
  @IBAction func statusAction(_ sender: Any) {
    if let actionType = actionType {
      handler?(self, actionType)
    }
  }
  
  fileprivate var actionType: Chat.SystemMessageAction?
  fileprivate var handler: Chat.SystemMessageActionHandler?
  
  override func awakeFromNib() {
    super.awakeFromNib()
    layer.shouldRasterize = true
    layer.rasterizationScale = UIScreen.main.scale
    
    messageBackgroundView.layer.cornerRadius = UIConstants.backgroundCornerRadius
    messageBackgroundView.clipsToBounds = true
    messageBackgroundView.layer.borderWidth = 1.0
    messageBackgroundView.layer.borderColor = UIConstants.Colors.messageBorder.cgColor
    actionButton.layer.borderWidth = 1.0
    actionButton.layer.cornerRadius = UIConstants.backgroundCornerRadius
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }
  
  func setViewModel(_ vm: ChatStatusMessageViewModelProtocol, handler: @escaping Chat.SystemMessageActionHandler) {
    messageLabel.text = vm.messageText
    messageLabel.textColor = vm.messageTextColor
    dateLabel.text = vm.date
    actionButton.setTitleForAllStates(vm.actionTitle)
    self.handler = handler
    
    switch vm.actionState {
    case .none:
      actionButton.isHidden = true
      actionButtonTopConstraint.constant = 0.0
      actionButtonHeightConstraint.constant = 0.0
    case .available(let actionType):
      self.actionType = actionType
      actionButton.isHidden = false
      actionButtonTopConstraint.constant = UIConstants.Constraints.actionButtonTopConstraint
      actionButtonHeightConstraint.constant =  UIConstants.Constraints.actionButtonHeight
      
      actionButton.layer.borderColor = UIConstants.Colors.ActionButtonBorder.available.cgColor
      actionButton.backgroundColor = UIConstants.Colors.ActionButtonBackground.available
      actionButton.setTitleColor(UIConstants.Colors.ActionButtonTitle.available, for: .normal)
    case .done:
      actionButton.isHidden = false
      actionButtonTopConstraint.constant = UIConstants.Constraints.actionButtonTopConstraint
      actionButtonHeightConstraint.constant =  UIConstants.Constraints.actionButtonHeight
      
      actionButton.layer.borderColor = UIConstants.Colors.ActionButtonBorder.done.cgColor
      actionButton.backgroundColor = UIConstants.Colors.ActionButtonBackground.done
      actionButton.setTitleColor(UIConstants.Colors.ActionButtonTitle.done, for: .normal)
    case .waiting:
      actionButton.isHidden = false
      actionButtonTopConstraint.constant = UIConstants.Constraints.actionButtonTopConstraint
      actionButtonHeightConstraint.constant =  UIConstants.Constraints.actionButtonHeight
      
      actionButton.layer.borderColor = UIConstants.Colors.ActionButtonBorder.waiting.cgColor
      actionButton.backgroundColor = UIConstants.Colors.ActionButtonBackground.waiting
      actionButton.setTitleColor(UIConstants.Colors.ActionButtonTitle.waiting, for: .normal)
    }
  }
}

fileprivate enum UIConstants {
  static let backgroundCornerRadius: CGFloat = 4
  
  enum Colors {
    static let messageBorder = UIColor.bluePibble
    
    
    enum ActionButtonBorder {
      static let available = UIColor.bluePibble
      static let done = UIColor.gray191
      static let waiting = UIColor.gray191
    }
    
    enum ActionButtonBackground {
      static let available = UIColor.white
      static let done = UIColor.white
      static let waiting = UIColor.gray191
    }
    
    enum ActionButtonTitle {
      static let available = UIColor.bluePibble
      static let done = UIColor.black
      static let waiting = UIColor.white
    }
  }
  
  enum Constraints {
    static let actionButtonHeight: CGFloat = 44.0
    static let actionButtonTopConstraint: CGFloat = 15.0
  }
}
