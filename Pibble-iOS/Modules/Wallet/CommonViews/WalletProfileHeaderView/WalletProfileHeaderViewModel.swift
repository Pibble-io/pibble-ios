//
//  WalletProfileHeaderViewModel.swift
//  Pibble
//
//  Created by Kazakov Sergey on 28.08.2018.
//  Copyright © 2018 com.kazai. All rights reserved.
//

import UIKit

extension Wallet {
  struct WalletProfileHeaderViewModel: WalletProfileHeaderViewModelProtocol {
    let userpicPlaceholder: UIImage?
    let userpicUrlString: String
    let username: String
    let pibbleBalance: String
    
    let greenBrushBalance: String
    let redBrushBalance: String
    
    init(userProfile: UserProtocol) {
      username = userProfile.userName.capitalized
      userpicUrlString = userProfile.userpicUrlString
      userpicPlaceholder = UIImage.avatarImageForNameString(userProfile.userName)
      
      let pibbleValue = userProfile.walletBalances.first { $0.currency == BalanceCurrency.pibble }?.value ?? 0.0
      let greenBrushValue = userProfile.walletBalances.first { $0.currency == BalanceCurrency.greenBrush }?.value ?? 0.0
      let redBrushValue = userProfile.walletBalances.first { $0.currency == BalanceCurrency.redBrush }?.value ?? 0.0

      pibbleBalance = String(format:"%.1f", pibbleValue)
      greenBrushBalance = String(format:"%.1f", greenBrushValue)
      redBrushBalance = String(format:"%.1f", redBrushValue)
    }
  }
}


