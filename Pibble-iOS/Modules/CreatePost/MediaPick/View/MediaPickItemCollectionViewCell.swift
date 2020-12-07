//
//  MediaPickItemCollectionViewCell.swift
//  Pibble
//
//  Created by Kazakov Sergey on 02.07.2018.
//  Copyright © 2018 com.kazai. All rights reserved.
//

import UIKit

class MediaPickItemCollectionViewCell: UICollectionViewCell {
  static let identifier = "MediaPickItemCollectionViewCell"
  @IBOutlet weak var itemImageView: UIImageView!
  @IBOutlet weak var durationLabel: UILabel!
  @IBOutlet weak var countLabel: UILabel!
  
  var indexPath: IndexPath?
  
  override func awakeFromNib() {
    super.awakeFromNib()
    countLabel.layer.cornerRadius = countLabel.bounds.width * 0.5
    countLabel.clipsToBounds = true
    countLabel.layer.borderWidth = 1.5
    countLabel.layer.borderColor = countLabel.textColor.cgColor
  }

  func setViewModel(_ vm: MediaPickItemViewModelProtocol) {
    itemImageView.image = vm.image
    durationLabel.text = vm.duration
    countLabel.backgroundColor = vm.isSelected ? UIConstants.Colors.countLabelBackgroundSelected : UIConstants.Colors.countLabelBackgroundDeselected
    countLabel.layer.borderColor = UIConstants.Colors.countLabelBorder.cgColor
    countLabel.text = vm.isSelected ? vm.count : ""
  }
}

fileprivate enum UIConstants {
  enum Colors {
  
    static let selection = UIColor.purple
    
    static let countLabelBorder = UIColor(white: 1.0, alpha: 0.5)
   
    static let countLabelBackgroundSelected = UIColor.greenPibble
    static let countLabelBackgroundDeselected = UIColor(white: 1.0, alpha: 0.1)
    
  }
  
}
