//
//  ChatMessagesHeaderView.swift
//  PlusOne
//
//  Created by Kazakov Sergey on 22.12.17.
//  Copyright © 2017 PlusOne. All rights reserved.
//

import UIKit

class ChatMessagesHeaderView: UITableViewHeaderFooterView, DequeueableView {

  @IBOutlet weak var backgroundRoundedView: UIView!
  @IBOutlet weak var headerTitleLabel: UILabel!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    backgroundRoundedView.clipsToBounds = true
    backgroundRoundedView.layer.cornerRadius = 14.0
  }
 
}
