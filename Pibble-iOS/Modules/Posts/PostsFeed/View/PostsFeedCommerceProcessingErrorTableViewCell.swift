//
//  PostsFeedCommerceProcessingErrorTableViewCell.swift
//  Pibble
//
//  Created by Sergey Kazakov on 04/02/2019.
//  Copyright © 2019 com.kazai. All rights reserved.
//

import UIKit

class PostsFeedCommerceProcessingErrorTableViewCell: UITableViewCell, DequeueableCell {
  
  @IBOutlet weak var errorIcon: UIImageView!
  
  @IBOutlet weak var errorMessageLabel: UILabel!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }
  
  func setViewModel(_ vm: PostsFeedCommercialErrorViewModelProtocol) {
    errorMessageLabel.text = vm.errorMessage
  }
}
