//
//  WalletTransactionCurrencyPickItemView.swift
//  Pibble
//
//  Created by Sergey Kazakov on 08/07/2019.
//  Copyright © 2019 com.kazai. All rights reserved.
//

import UIKit

typealias WalletTransactionCurrencyPickItemViewActionHandler = (WalletTransactionCurrencyPickItemView) -> Void

class WalletTransactionCurrencyPickItemView: NibLoadingView {
  @IBOutlet fileprivate var contentView: UIView!
  @IBOutlet weak var selectionImageView: UIImageView!
  @IBOutlet weak var titleLabel: UILabel!
  
  fileprivate var handler: WalletTransactionCurrencyPickItemViewActionHandler?
  
  @IBAction func selectAction(_ sender: Any) {
    handler?(self)
  }
  
  func setViewModel(_ vm: WalletTransactionCurrencyPickItemViewModelProtocol, handler: @escaping WalletTransactionCurrencyPickItemViewActionHandler) {
    self.handler = handler
    
    selectionImageView.image = vm.isSelected ?
      UIImage(imageLiteralResourceName: "WalletTransactionCurrencyPick-RoundedCheckBox-selected"):
      UIImage(imageLiteralResourceName: "WalletTransactionCurrencyPick-RoundedCheckBox")
    titleLabel.text = vm.title
  }
}
