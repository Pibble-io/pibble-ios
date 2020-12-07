//
//  PostsFeedLocationTableViewCell.swift
//  Pibble
//
//  Created by Kazakov Sergey on 24.09.2018.
//  Copyright © 2018 com.kazai. All rights reserved.
//

import UIKit

typealias PostsFeedLocationTableViewCellActionHandler = (PostsFeedLocationTableViewCell) -> Void

class PostsFeedLocationTableViewCell: UITableViewCell, DequeueableCell {
  @IBOutlet weak var locationDescriptionLabel: UILabel!
  
  @IBOutlet weak var locationIconImageView: UIImageView!
 
  @IBAction func locationSelectAction(_ sender: Any) {
    handler?(self)
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
    layer.shouldRasterize = true
    layer.rasterizationScale = UIScreen.main.scale
  }
  
  fileprivate var handler: PostsFeedLocationTableViewCellActionHandler?
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }
  
  func setViewModel(_ vm: PostsFeedItemLocationViewModelProtocol, handler: @escaping PostsFeedLocationTableViewCellActionHandler) {
    self.handler = handler
    
    locationDescriptionLabel.text = vm.locationDescription
    
    locationDescriptionLabel.textColor = vm.isHighlighted ?
      UIConstants.Colors.highlightedText :
      UIConstants.Colors.unhighlightedText
    
    locationIconImageView.image = vm.isHighlighted ?
      UIImage(imageLiteralResourceName: "PostsFeed-LocationIcon-selected") :
      UIImage(imageLiteralResourceName: "PostsFeed-LocationIcon")
  }
}

fileprivate enum UIConstants {
  enum Colors {
    static let highlightedText = UIColor.bluePibble
    static let unhighlightedText = UIColor.gray112
  }
}
