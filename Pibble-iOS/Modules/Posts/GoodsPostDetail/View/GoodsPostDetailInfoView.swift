//
//  DigitalPostDetailInfoView.swift
//  Pibble-iOS
//
//  Created by Sergey Kazakov on 02/08/2019.
//  Copyright © 2019 com.kazai. All rights reserved.
//

import UIKit

class GoodsPostDetailInfoView: NibLoadingView {
  @IBOutlet fileprivate var contentView: UIView!
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var priceAmountLabel: UILabel!
  @IBOutlet weak var urlLabel: UILabel!
  @IBOutlet weak var isNewConditionLabel: UILabel!
  
  func setViewModel(_ vm: GoodsPostDetailInfoViewModelProtocol) {
    titleLabel.text = vm.title
    priceAmountLabel.text = vm.price
    urlLabel.text = vm.urlString
    isNewConditionLabel.isHidden = !vm.isNew
  }
}
