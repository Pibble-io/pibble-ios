//
//  PostsFeedGoodPriceTableViewCell.swift
//  Pibble-iOS
//
//  Created by Sergey Kazakov on 01/08/2019.
//  Copyright © 2019 com.kazai. All rights reserved.
//

import UIKit
 
class PostsFeedGoodPriceTableViewCell: UITableViewCell, DequeueableCell {
  
  @IBOutlet weak var commercialPostPrice: UILabel!
  
  @IBOutlet weak var isNewStatusLabel: UILabel!
  @IBOutlet weak var availabilityStatusLabel: UILabel!
  
  @IBAction func selectItemAction(_ sender: Any) {
    handler?(self, .detail)
  }
  
  fileprivate var handler: PostsFeed.CommercialPostActionsHandler?
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }
  
  func setViewModel(_ vm: PostsFeedGoodsInfoViewModelProtocol, handler: @escaping PostsFeed.CommercialPostActionsHandler) {
    self.handler = handler
    
    availabilityStatusLabel.isHidden = !vm.isAvailabilityStatusVisible
    availabilityStatusLabel.text = vm.availabilityStatusString
    
    commercialPostPrice.text = vm.commercialPostPrice
    isNewStatusLabel.isHidden = !vm.isNewGood
  }
}

