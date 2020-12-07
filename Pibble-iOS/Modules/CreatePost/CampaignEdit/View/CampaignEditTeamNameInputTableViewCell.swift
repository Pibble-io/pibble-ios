//
//  CampaignEditTeamNameInputTableViewCell.swift
//  Pibble
//
//  Created by Kazakov Sergey on 27.10.2018.
//  Copyright © 2018 com.kazai. All rights reserved.
//

import UIKit

typealias CampaignEditTeamNameInputTableViewCellActionHandler = (CampaignEditTeamNameInputTableViewCell, CampaignEdit.TeamNameInputActions) -> Void

class CampaignEditTeamNameInputTableViewCell: UITableViewCell, DequeueableCell {
  @IBOutlet weak var nameTextField: UITextField!
  @IBOutlet weak var textFieldContainerView: UIView!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    textFieldContainerView.layer.cornerRadius = UIConstants.inputCornerRadius
    textFieldContainerView.clipsToBounds = true
    textFieldContainerView.layer.borderWidth = 1.0
    textFieldContainerView.layer.borderColor = UIConstants.Colors.inputBorder.cgColor
  }
  
  @IBAction func nameTextFieldValueChangedAction(_ sender: Any) {
    handler?(self, .titleTextChanged(nameTextField.text ?? ""))
  }
  
  @IBAction func nameTextFieldEndEditAction(_ sender: Any) {
    handler?(self, .endEditing)
  }
  
  fileprivate var handler: CampaignEditTeamNameInputTableViewCellActionHandler?
  
  func setViewModel(_ vm: CampaignEditTeamNameViewModelProtocol, handler: @escaping CampaignEditTeamNameInputTableViewCellActionHandler) {
    self.handler = handler
    nameTextField.text = vm.title
    nameTextField.attributedPlaceholder = vm.attributedPlaceholder
  }
}


fileprivate enum UIConstants {
  static let inputCornerRadius: CGFloat = 5.0
  
  enum Colors {
    static let inputBorder = UIColor.gray191
  }
}
