//
//  PostMessageContentDownloadTableViewCell.swift
//  Pibble
//
//  Created by Sergey Kazakov on 17/02/2019.
//  Copyright © 2019 com.kazai. All rights reserved.
//

import UIKit

class ChatDigitalGoodPostMessageContentDownloadActionTableViewCell: UITableViewCell, DequeueableCell {
  
  @IBOutlet weak var downloadButton: UIButton!
  
  @IBAction func downloadAction(_ sender: Any) {
    handler?(self, .download)
  }
  
  fileprivate var handler: Chat.MessageActionHandler?

  override func awakeFromNib() {
    super.awakeFromNib()
    layer.shouldRasterize = true
    layer.rasterizationScale = UIScreen.main.scale
  }
  
  func setViewModel(handler: @escaping Chat.MessageActionHandler) {
    self.handler = handler
    
    downloadButton.setTitleColor(UIConstants.Colors.downloadButtonBorder, for: .normal)
    downloadButton.layer.cornerRadius = 7.0
    downloadButton.layer.borderWidth = 1.0
    downloadButton.layer.borderColor = UIConstants.Colors.downloadButtonBorder.cgColor
  }
}

fileprivate enum UIConstants {
  enum Colors {
    static let downloadButtonBorder = UIColor.bluePibble
  }
}
