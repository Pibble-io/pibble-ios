//
//  WalletPayBillModuleScope.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 28.08.2018.
//Copyright © 2018 com.kazai. All rights reserved.
//

import UIKit

enum WalletPayBill {
  enum ItemViewModelType {
    case invoice(WalletActivityInvoiceViewModelProtocol)
    case loadingPlaceholder
  }
}
