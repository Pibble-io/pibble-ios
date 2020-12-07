//
//  WalletReceiveWalledAddressTypeView.swift
//  Pibble
//
//  Created by Sergey Kazakov on 06/07/2019.
//  Copyright © 2019 com.kazai. All rights reserved.
//

import UIKit

typealias WalletReceiveWalledAddressTypeViewActionHandler = (WalletReceiveWalledAddressTypeView) -> Void

class WalletReceiveWalledAddressTypeView: NibLoadingView {
  @IBOutlet fileprivate var contentView: UIView!
  @IBOutlet weak var selectionImageView: UIImageView!
  @IBOutlet weak var titleLabel: UILabel!
  
  fileprivate var handler: WalletReceiveWalledAddressTypeViewActionHandler?
  
  @IBAction func selectAction(_ sender: Any) {
    handler?(self)
  }
  
  
  func setViewModel(_ vm: WalletReceiveAddressTypeViewModelProtocol, handler: @escaping WalletReceiveWalledAddressTypeViewActionHandler) {
    self.handler = handler
    
    selectionImageView.image = vm.isSelected ?
      UIImage(imageLiteralResourceName: "WalletRecieve-RoundedCheckBox-selected"):
      UIImage(imageLiteralResourceName: "WalletRecieve-RoundedCheckBox")
    titleLabel.text = vm.title
  }
}
