//
//  ReportPostTableViewCell.swift
//  Pibble
//
//  Created by Sergey Kazakov on 01/05/2019.
//  Copyright © 2019 com.kazai. All rights reserved.
//

import UIKit

class ReportPostTableViewCell: UITableViewCell, DequeueableCell {
  
  @IBOutlet weak var reasonTitle: UILabel!
  
  func setViewModel(_ vm: ReportPostItemViewModelProtocol) {
    reasonTitle.text = vm.title
  }
}
