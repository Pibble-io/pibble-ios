//
//  CampaignEditTitleTableViewCell.swift
//  Pibble
//
//  Created by Kazakov Sergey on 24.10.2018.
//  Copyright © 2018 com.kazai. All rights reserved.
//

import UIKit

typealias CampaignEditTitleInputTableViewCellActionHandler = (CampaignEditTitleInputTableViewCell, CampaignEdit.TitleInputActions) -> Void

class CampaignEditTitleInputTableViewCell: UITableViewCell, DequeueableCell {
  @IBOutlet weak var titleTextField: UITextField!
  @IBOutlet weak var backgroundContainerView: UIView!
  
  @IBAction func titleEditingEndAction(_ sender: Any) {
    handler?(self, .endEditing)
  }
  
  @IBAction func titleEditingChangedAction(_ sender: Any) {
    handler?(self, .titleTextChanged(titleTextField.text ?? ""))
  }
  
  fileprivate var handler: CampaignEditTitleInputTableViewCellActionHandler?
  
  func setViewModel(_ vm: CampaignEditTitleViewModelProtocol, handler: @escaping CampaignEditTitleInputTableViewCellActionHandler) {
    self.handler = handler
    titleTextField.text = vm.title
    titleTextField.attributedPlaceholder = vm.attributedPlaceholder
    backgroundContainerView.layer.cornerRadius = 4.0
    backgroundContainerView.clipsToBounds = true
  }
}
