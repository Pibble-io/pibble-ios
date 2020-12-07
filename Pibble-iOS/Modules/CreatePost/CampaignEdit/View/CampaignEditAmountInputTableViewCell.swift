//
//  CampaignEditAmountInputTableViewCell.swift
//  Pibble
//
//  Created by Kazakov Sergey on 24.10.2018.
//  Copyright © 2018 com.kazai. All rights reserved.
//

import UIKit

typealias CampaignEditAmountInputTableViewCellActionHandler = (CampaignEditAmountInputTableViewCell, CampaignEdit.AmountInputActions) -> Void

class CampaignEditAmountInputTableViewCell: UITableViewCell, DequeueableCell {
  @IBOutlet weak var currencyLabel: UILabel!
  @IBOutlet weak var amountTextField: UITextField!
  @IBOutlet weak var campaignTypeIconImageView: UIImageView!
  
  @IBOutlet weak var backgroundContainerView: UIView!
  
  @IBOutlet weak var amountInputContainerView: UIView!
  
  @IBAction func amountEditingEndedAction(_ sender: Any) {
    handler?(self, .amountTextEndEditing)
  }
  
  @IBAction func amountEditingChangedAction(_ sender: Any) {
    handler?(self, .amountTextValueChanged(amountTextField.text ?? ""))
    guard let vm = viewModel else {
      return
    }

    amountTextField.text = vm.limitedValueStringFor(amountTextField.text ?? "")
  }
  
  fileprivate var handler: CampaignEditAmountInputTableViewCellActionHandler?
  fileprivate var viewModel: CampaignEditAmountInputViewModelProtocol?
  
  override func awakeFromNib() {
    super.awakeFromNib()
    amountInputContainerView.layer.borderColor = UIConstants.Colors.amountInputBoarderColor.cgColor
    amountInputContainerView.layer.borderWidth = 1.0
    amountInputContainerView.layer.cornerRadius = 4.0
  }
  
  func setViewModel(_ vm: CampaignEditAmountInputViewModelProtocol, handler: @escaping CampaignEditAmountInputTableViewCellActionHandler) {
    viewModel = vm
    self.handler = handler
    
    campaignTypeIconImageView.image = vm.campaignTypeIconImage
    amountTextField.text = vm.currentAmountString
    
    backgroundContainerView.layer.cornerRadius = 4.0
    backgroundContainerView.clipsToBounds = true
  }
}

fileprivate enum UIConstants {
  enum Colors {
    static let amountInputBoarderColor = UIColor.gray191
  }
}
