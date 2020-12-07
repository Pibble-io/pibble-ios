//
//  CommercialPostDetailMessageButtonTableViewCell.swift
//  Pibble
//
//  Created by Sergey Kazakov on 07/02/2019.
//  Copyright © 2019 com.kazai. All rights reserved.
//

import UIKit

class CommercialPostDetailMessageButtonTableViewCell: UITableViewCell, DequeueableCell {
  fileprivate var handler: CommercialPostDetail.ActionHandler?
  
  @IBOutlet weak var messageButton: UIButton!
  
  @IBAction func messageAction(_ sender: Any) {
    handler?(self, .messages)
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
    messageButton.layer.cornerRadius = UIConstants.CornerRadius.button
    messageButton.clipsToBounds = true
    
    messageButton.layer.borderWidth = 1.0
    messageButton.layer.borderColor = UIConstants.Colors.buttonBorder.cgColor
  }
  
  func setViewModel(handler: @escaping CommercialPostDetail.ActionHandler) {
    self.handler = handler
  }
}

fileprivate enum UIConstants {
  enum CornerRadius {
    static let button: CGFloat = 4.0
  }
  
  enum Colors {
    static let buttonBorder = UIColor.gray222
  }
}
