//
//  TableViewAutolayoutHeadersFootersExtensions.swift
//  Pibble
//
//  Created by Sergey Kazakov on 15/03/2019.
//  Copyright © 2019 com.kazai. All rights reserved.
//

import UIKit

extension UITableView {
  //set the tableHeaderView so that the required height can be determined, update the header's frame and set it again
  func setAndLayoutTableHeaderView(header: UIView) {
    self.tableHeaderView = header
    header.setNeedsLayout()
    header.layoutIfNeeded()
    header.frame.size = header.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
    tableHeaderView = header
  }
  
  func setAndLayoutTableFooterView(footer: UIView) {
    tableFooterView = footer
    footer.setNeedsLayout()
    footer.layoutIfNeeded()
    footer.frame.size = footer.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
    tableFooterView = footer
  }
}
