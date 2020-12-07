//
//  PostsFeedTopGroupCollectionViewCell.swift
//  Pibble
//
//  Created by Sergey Kazakov on 17/07/2019.
//  Copyright © 2019 com.kazai. All rights reserved.
//

import UIKit

typealias PostsFeedTopGroupItemSelectionHandler = (UICollectionViewCell) -> Void

class PostsFeedTopGroupCollectionViewCell: UICollectionViewCell, DequeueableCell {
  
  override func awakeFromNib() {
    super.awakeFromNib()
    layer.shouldRasterize = true
    layer.rasterizationScale = UIScreen.main.scale
  }
  
  @IBOutlet weak var groupImageView: UIImageView!
  @IBOutlet weak var groupTitle: UILabel!
  
  @IBAction func selectionAction(_ sender: Any) {
    handler?(self)
  }
  
  fileprivate var handler: PostsFeedTopGroupItemSelectionHandler?
  
  func setViewModel(_ vm: PostsFeedTopGroupItemViewModelProtocol, handler: @escaping PostsFeedTopGroupItemSelectionHandler) {
    self.handler = handler
    groupImageView.image = vm.image
    groupTitle.text = vm.title
    groupImageView.setCornersToCircleByHeight()
    groupImageView.layer.borderWidth = 1.0
    groupImageView.layer.borderColor = vm.isSelected ?
      UIConstants.Colors.borderSelected.cgColor :
      UIConstants.Colors.borderDeselected.cgColor
    
    groupTitle.textColor = vm.isSelected ?
      UIConstants.Colors.titleSelected :
      UIConstants.Colors.titleDeselected
  }
}

fileprivate enum UIConstants {
  enum Colors {
    static let borderSelected = UIColor.bluePibble
    static let borderDeselected = UIColor.gray227
    
    static let titleSelected = UIColor.bluePibble
    static let titleDeselected = UIColor.black
  }
}
