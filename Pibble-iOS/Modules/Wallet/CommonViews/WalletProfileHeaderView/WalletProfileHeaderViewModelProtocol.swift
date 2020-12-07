//
//  WalletProfileHeaderViewModelProtocol.swift
//  Pibble
//
//  Created by Kazakov Sergey on 23.08.2018.
//  Copyright © 2018 com.kazai. All rights reserved.
//

import UIKit

protocol WalletProfileHeaderViewModelProtocol {
  
  var userpicPlaceholder: UIImage? { get }
  var userpicUrlString: String { get }
  var username: String { get }
  var pibbleBalance: String { get }
  var greenBrushBalance: String { get }
  var redBrushBalance: String { get }
}
