//
//  CommercialPostDetailAgreementTableViewCell.swift
//  Pibble
//
//  Created by Sergey Kazakov on 07/02/2019.
//  Copyright © 2019 com.kazai. All rights reserved.
//

import UIKit

class CommercialPostDetailAgreementTableViewCell: UITableViewCell, DequeueableCell {
  fileprivate var handler: CommercialPostDetail.ActionHandler?
  
  @IBOutlet weak var agreementTitleLable: UILabel!
  
  @IBAction func showAgreementAction(_ sender: Any) {
    handler?(self, .presentAgreement)
  }
  
  func setViewModel(_ vm: CommercialPostDetailAgreementViewModelProtocol, handler: @escaping CommercialPostDetail.ActionHandler) {
    self.handler = handler
    self.agreementTitleLable.attributedText = vm.agreementTitle
  }
}
