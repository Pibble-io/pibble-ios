//
//  CommercialPostDetailLicensingTableViewCell.swift
//  Pibble
//
//  Created by Sergey Kazakov on 07/02/2019.
//  Copyright © 2019 com.kazai. All rights reserved.
//

import UIKit

class CommercialPostDetailLicensingTableViewCell: UITableViewCell, DequeueableCell {
  @IBOutlet weak var containerView: UIView!
 
  @IBOutlet weak var commercialUseCheckImageView: UIImageView!
  @IBOutlet weak var editorialUseCheckImageView: UIImageView!
  @IBOutlet weak var royaltyFreeUseCheckImageView: UIImageView!
  @IBOutlet weak var exclusiveUseCheckImageView: UIImageView!
  
  @IBOutlet weak var dowloadableLabel: UILabel!
  
  @IBOutlet weak var commercialUseLabel: UILabel!
  @IBOutlet weak var editorialUseLabel: UILabel!
  @IBOutlet weak var royaltyFreeUseLabel: UILabel!
  @IBOutlet weak var exclusiveUseLabel: UILabel!
  
  func setViewModel(_ vm: CommercialPostDetailLicensingViewModelProtocol) {
    dowloadableLabel.text = vm.isDownloadableString
    
    commercialUseCheckImageView.isHidden = !vm.commercialUseAllowed
    editorialUseCheckImageView.isHidden = !vm.editorialUseAllowed
    royaltyFreeUseCheckImageView.isHidden = !vm.royaltyFreeUseAllowed
    exclusiveUseCheckImageView.isHidden = !vm.exclusiveUseAllowed
    
    commercialUseLabel.alpha = vm.commercialUseAllowed ? 1.0 : 0.5
    editorialUseLabel.alpha = vm.editorialUseAllowed ? 1.0 : 0.5
    royaltyFreeUseLabel.alpha = vm.royaltyFreeUseAllowed ? 1.0 : 0.5
    exclusiveUseLabel.alpha = vm.exclusiveUseAllowed ? 1.0 : 0.15
    
  }
}
