//
//  UITableViewScrollToRowExtension.swift
//  Pibble-iOS
//
//  Created by Sergey Kazakov on 22/10/2019.
//  Copyright © 2019 com.kazai. All rights reserved.
//

import UIKit

extension UITableView {
  func scrollToRowIfExists(at indexPath: IndexPath, at scrollPosition: UITableView.ScrollPosition, animated: Bool) {
    guard indexPath.section < numberOfSections,
      indexPath.row < numberOfRows(inSection: indexPath.section) else {
        return
    }
    
    scrollToRow(at: indexPath, at: scrollPosition, animated: animated)
  }
}

