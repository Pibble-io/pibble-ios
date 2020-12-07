//
//  PostsFeedAddPromotionTableViewCell.swift
//  Pibble
//
//  Created by Sergey Kazakov on 09/06/2019.
//  Copyright © 2019 com.kazai. All rights reserved.
//

import UIKit

class PostsFeedAddPromotionTableViewCell: UITableViewCell, DequeueableCell {
  
  @IBOutlet weak var viewEngageButton: UIButton!
  
  @IBOutlet weak var addPromotionButton: UIButton!
  
  @IBAction func viewEngageAction(_ sender: Any) {
    handler?(self, .showEngagement)
  }
  
  @IBAction func addPromotionAction(_ sender: Any) {
    handler?(self, .add)
  }
  
  fileprivate var handler: PostsFeed.PromotionActionsTableViewCellHandler?
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
    addPromotionButton.layer.cornerRadius = UIConstants.addButtonCornerRadius
    addPromotionButton.clipsToBounds = true
  }
  
  func setViewModel(_ vm: PostsFeedAddPromotionViewModelProtocol, handler: @escaping PostsFeed.PromotionActionsTableViewCellHandler) {
    self.handler = handler
    addPromotionButton.isHidden = !vm.isAddButtonVisible
    addPromotionButton.backgroundColor = vm.addButtonColor
  }
}

fileprivate enum UIConstants {
  static let addButtonCornerRadius: CGFloat = 4.0
}
