//
//  PromotionUrlDestinationPickButtonActionTableViewCell.swift
//  Pibble
//
//  Created by Sergey Kazakov on 24/05/2019.
//  Copyright © 2019 com.kazai. All rights reserved.
//

import UIKit

class PromotionUrlDestinationPickButtonActionTableViewCell: UITableViewCell, DequeueableCell {
  @IBOutlet weak var buttonActionTitleLabel: UILabel!
  @IBOutlet weak var selectionImageView: UIImageView!
  
  func setViewModel(_ vm: PromotionUrlDestinationPickButtonActionViewModelProtocol) {
    buttonActionTitleLabel.text = vm.title
    selectionImageView.image = vm.selectionImage
  }
}
