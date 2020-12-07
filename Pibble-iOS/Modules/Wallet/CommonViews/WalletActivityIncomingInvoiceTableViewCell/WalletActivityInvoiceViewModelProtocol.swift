//
//  WalletActivityInvoiceViewModelProtocol.swift
//  Pibble
//
//  Created by Kazakov Sergey on 29.08.2018.
//  Copyright © 2018 com.kazai. All rights reserved.
//

import UIKit

protocol WalletActivityInvoiceViewModelProtocol {
  var invoiceTitle: NSAttributedString { get }
  var userpicPlacholder: UIImage? { get }
  var userpicUrlString: String { get }
  var isIncoming: Bool { get }
  var invoiceDate: String { get }
  var invoiceValue: String { get }
  var invoiceNote: String { get }
  
  var shouldPresentActions: Bool { get }
  var currencyColor: UIColor { get }
}
