//
//  TabBarActionsMenuCollectionViewCell.swift
//  Pibble
//
//  Created by Kazakov Sergey on 30.06.2018.
//  Copyright © 2018 com.kazai. All rights reserved.
//

import UIKit

class TabBarActionsItemCollectionViewCell: UICollectionViewCell {
  static let identifier = "TabBarActionsItemCollectionViewCell"
  
  @IBOutlet weak var itemImageView: UIImageView!
  @IBOutlet weak var itemTitleLabel: UILabel!
  @IBOutlet weak var actionBackgroundView: UIView!
  @IBOutlet weak var shadowBackgroundView: UIView!
  
  override var bounds: CGRect {
    didSet {
      shadowBackgroundView.layer.shadowPath = UIBezierPath(roundedRect: shadowBackgroundView.bounds, cornerRadius: shadowBackgroundView.bounds.size.width * 0.5).cgPath
    }
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
    
    actionBackgroundView.layer.cornerRadius = actionBackgroundView.bounds.width * 0.5
    actionBackgroundView.clipsToBounds = true
//    
//    shadowBackgroundView.layer.cornerRadius = shadowBackgroundView.bounds.width * 0.5
//    shadowBackgroundView.addShadow(shadowColor: UIColor.black,
//                                   offSet: CGSize(width: 1.0, height: 1.0),
//                                   opacity: 0.3,
//                                   radius: 3.0)
    
  }
  
  func setViewModel(_ vm: TabBarMenuItemViewModelProtocol) {
    itemTitleLabel.text = vm.title
    itemImageView.image = vm.image
  }
  
  override var isSelected: Bool {
    didSet {
      actionBackgroundView.backgroundColor = isSelected ? UIConstants.Colors.backgroundSelected :
        UIConstants.Colors.backgroundUnselected
    }
  }
}

fileprivate enum UIConstants {
  enum Colors {
    static let backgroundSelected = UIColor.bluePibble
    static let backgroundUnselected = UIColor.menuItemGreen
  }
}
