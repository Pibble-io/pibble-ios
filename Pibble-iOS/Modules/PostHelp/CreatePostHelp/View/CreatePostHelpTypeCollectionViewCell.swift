//
//  CreatePostHelpTypeCollectionViewCell.swift
//  Pibble-iOS
//
//  Created by Sergey Kazakov on 27/09/2019.
//  Copyright © 2019 com.kazai. All rights reserved.
//

import UIKit

class CreatePostHelpTypeCollectionViewCell: UICollectionViewCell, DequeueableCell {
  @IBOutlet weak var titleLabel: UILabel!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    setCornersToCircleByHeight()
    layer.borderColor = UIConstants.Colors.bounds.cgColor
    layer.borderWidth = 1.0
  }
  
  func setViewModel(_ vm: CreatePostHelpTypeItemViewModelProtocol) {
    titleLabel.text = vm.title
  }
}


fileprivate enum UIConstants {
  enum Colors {
    static let bounds = UIColor.gray84
  }
}
