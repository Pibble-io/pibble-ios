//
//  WalletProfileHeaderView.swift
//  Pibble
//
//  Created by Kazakov Sergey on 23.08.2018.
//  Copyright © 2018 com.kazai. All rights reserved.
//

import UIKit

class WalletProfileHeaderView: NibLoadingView {

  @IBOutlet var contentView: UIView!
  @IBOutlet weak var userpicImageView: UIImageView!
  @IBOutlet weak var usernameLabel: UILabel!
  @IBOutlet weak var pibbleAmountLabel: UILabel!
  @IBOutlet weak var greenBrushAmountLabel: UILabel!
  @IBOutlet weak var redBrushAmountLabel: UILabel!
  
  
  override func setupView() {
    super.setupView()
    userpicImageView.setCornersToCircle()
  }
  
  func setViewModel(_ viewModel: WalletProfileHeaderViewModelProtocol?) {
    guard let vm = viewModel else {
      contentView.alpha = 0.0
      return
    }
    
    usernameLabel.text = vm.username
    userpicImageView.image = vm.userpicPlaceholder
    userpicImageView.setCachedImageOrDownload(vm.userpicUrlString)
    pibbleAmountLabel.text = vm.pibbleBalance
    redBrushAmountLabel.text = vm.redBrushBalance
    greenBrushAmountLabel.text = vm.greenBrushBalance
    UIView.animate(withDuration: 0.3) { [weak self] in
      self?.contentView.alpha = 1.0
    }
  }
}


