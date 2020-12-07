//
//  CommercialPostDetailGoodsInfoTableViewCellTableViewCell.swift
//  Pibble-iOS
//
//  Created by Sergey Kazakov on 04/08/2019.
//  Copyright © 2019 com.kazai. All rights reserved.
//

import UIKit

class CommercialPostDetailGoodsInfoTableViewCellTableViewCell: UITableViewCell, DequeueableCell {
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var priceAmountLabel: UILabel!
  @IBOutlet weak var urlLabel: UILabel!
  @IBOutlet weak var isNewConditionLabel: UILabel!
  
  @IBOutlet weak var containerView: UIView!
  
  @IBAction func openUrlAction(_ sender: Any) {
    handler?(self, .showGoodsURL)
  }
  
  fileprivate var handler: CommercialPostDetail.ActionHandler?
  
  override func awakeFromNib() {
    super.awakeFromNib()
    containerView.clipsToBounds = true
    containerView.layer.cornerRadius = UIConstants.CornerRadius.contentView
  }
  
  func setViewModel(_ vm: CommercialPostDetailGoodsInfoViewModelProtocol, handler: @escaping CommercialPostDetail.ActionHandler) {
    self.handler = handler
    titleLabel.text = vm.title
    priceAmountLabel.text = vm.price
    urlLabel.text = vm.urlString
    isNewConditionLabel.isHidden = !vm.isNew
  }
}

fileprivate enum UIConstants {
  enum CornerRadius {
    static let contentView: CGFloat = 12.0
  }
}
