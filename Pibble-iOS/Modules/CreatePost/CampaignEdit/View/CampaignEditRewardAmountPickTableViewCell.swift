//
//  CampaignEditRewardAmountPickTableViewCell.swift
//  Pibble-iOS
//
//  Created by Sergey Kazakov on 03/09/2019.
//  Copyright © 2019 com.kazai. All rights reserved.
//

import UIKit

typealias CampaignEditRewardAmountPickTableViewCellActionHandler = (UITableViewCell, CampaignEdit.RewardAmountInputActions) -> Void

class CampaignEditRewardAmountPickTableViewCell: UITableViewCell, DequeueableCell {
  
  @IBOutlet weak var inputsTypeTitleLabel: UILabel!
  
  
  @IBOutlet weak var firstInputValueTitleLabel: UILabel!
  @IBOutlet var inputContainers: [UIView]!
  
  @IBOutlet var inputsTextFields: [UITextField]!
  
  @IBAction func nameTextFieldValueChangedAction(_ sender: UITextField) {
    if sender == inputsTextFields.first {
       handler?(self, .firstAmountInputChanged(sender.text ?? ""))
    }
   
    if sender == inputsTextFields.last {
      handler?(self, .secondAmountInputChanged(sender.text ?? ""))
    }
  }
  
  @IBAction func nameTextFieldEndEditAction(_ sender: UITextField) {
    if sender == inputsTextFields.first {
      handler?(self, .firstAmountInputEndEditing)
    }
    
    if sender == inputsTextFields.last {
      handler?(self, .secondAmountInputEndEditing)
    }
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
    inputContainers.forEach {
      $0.layer.cornerRadius = UIConstants.inputCornerRadius
      $0.layer.borderWidth = 1.0
      $0.layer.borderColor = UIConstants.Colors.inputBorder.cgColor
    }
  }
  
  fileprivate var handler: CampaignEditRewardAmountPickTableViewCellActionHandler?
  
  func setViewModel(_ vm: CampaignEditRewardAmountPickViewModelProtocol, handler: @escaping CampaignEditRewardAmountPickTableViewCellActionHandler) {
    self.handler = handler
    
    inputsTypeTitleLabel.text = vm.title
    
    inputsTextFields.first?.text = vm.amounts.0
    inputsTextFields.first?.attributedPlaceholder = vm.attributedPlaceholders.0
    
    firstInputValueTitleLabel.text = vm.amountValueTitle.0
    
    inputsTextFields.last?.text = vm.amounts.1
    inputsTextFields.last?.attributedPlaceholder = vm.attributedPlaceholders.1
    
    inputContainers.last?.isHidden = !vm.hasSecondInput
  }
}

fileprivate enum UIConstants {
  static let inputCornerRadius: CGFloat = 5.0
  
  enum Colors {
    static let inputBorder = UIColor.gray191
  }
}
