//
//  WalletPreviewModuleScope.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 15.10.2018.
//Copyright © 2018 com.kazai. All rights reserved.
//

import UIKit

enum WalletPreview {
  struct ItemViewModel: WalletPreviewItemViewModelProtocol {
    let itemImage: UIImage
    let itemAmount: String
    let itemTitle: String
  }
}
