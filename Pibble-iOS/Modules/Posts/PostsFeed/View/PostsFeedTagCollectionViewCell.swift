//
//  PostsFeedTagCollectionViewCell.swift
//  Pibble
//
//  Created by Kazakov Sergey on 02.08.2018.
//  Copyright © 2018 com.kazai. All rights reserved.
//

import UIKit

typealias PostsFeedTagCollectionViewCellSelectionHandler = (PostsFeedTagCollectionViewCell) -> Void

class PostsFeedTagCollectionViewCell: UICollectionViewCell, DequeueableCell {
  @IBOutlet weak var tagsLabel: UILabel!
  
  @IBAction func selectAction(_ sender: Any) {
    handler?(self)
  }
  
  fileprivate var handler: PostsFeedTagCollectionViewCellSelectionHandler?
  
  override func awakeFromNib() {
    super.awakeFromNib()
    layer.shouldRasterize = true
    layer.rasterizationScale = UIScreen.main.scale
    
    layer.borderWidth = 1.0
    layer.borderColor = UIConstants.Colors.border.cgColor
    layer.cornerRadius = 5.0
  }
  
  func setViewModel(_ vm: PostsFeedTagViewModelProtocol, handler: @escaping PostsFeedTagCollectionViewCellSelectionHandler) {
    self.handler = handler
    tagsLabel.text = vm.tagTitle
    tagsLabel.textColor = vm.isPromoted ?
      UIConstants.Colors.promotedText :
      UIConstants.Colors.text
    
    layer.borderColor = vm.isPromoted ?
      UIConstants.Colors.promotedBorder.cgColor :
      UIConstants.Colors.border.cgColor
    
    layer.borderWidth = vm.tagTitle.count > 0 ? 1.0 : 0.0
  }
}

fileprivate enum UIConstants {
  enum Colors {
    static let border = UIColor.grayBlue
    static let promotedBorder = UIColor.bluePibble
    
    static let text = UIColor.gray119
    static let promotedText = UIColor.bluePibble
  }
}
