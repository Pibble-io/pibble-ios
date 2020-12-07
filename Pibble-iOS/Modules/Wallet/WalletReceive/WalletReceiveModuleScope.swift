//
//  WalletReceiveModuleScope.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 30.08.2018.
//Copyright © 2018 com.kazai. All rights reserved.
//

import UIKit

enum WalletReceive {
  struct AccountInformationViewModel: WalletReceiveAccountInformationViewModelProtocol {
    let address: String
    let qrCodeImage: UIImage
    let currencyReceiveAddressTitle: NSAttributedString
  }
  
  struct AddressTypeViewModel: WalletReceiveAddressTypeViewModelProtocol {
    var isSelected: Bool
    var title: String
  }
  
  struct AddressTypesSectionViewModel: WalletReceiveAddressTypesSectionViewModelProtocol {
    let adressTypes: [WalletReceiveAddressTypeViewModelProtocol]
    
    init(wallets: [WalletProtocol], selectedWallets: WalletProtocol?) {
      adressTypes = wallets
        .map { AddressTypeViewModel(isSelected: $0.walletCurrency == selectedWallets?.walletCurrency,
                                    title: $0.walletCurrency.rawSymbolPresentation) }
    }
  }
}
