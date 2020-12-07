//
//  LocationSuggestionTableViewCell.swift
//  Pibble
//
//  Created by Kazakov Sergey on 23.07.2018.
//  Copyright © 2018 com.kazai. All rights reserved.
//

import UIKit

class LocationSuggestionTableViewCell: UITableViewCell {
  static let identifier = "LocationSuggestionTableViewCell"
  
  @IBOutlet weak var separatorView: UIView!
  
  @IBOutlet weak var locationTitleLabel: UILabel!
  @IBOutlet weak var locationDescription: UILabel!
  
  override func awakeFromNib() {
    super.awakeFromNib()
   
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }
  
  func setViewModel(_ vm: LocationItemViewModelProtocol) {
    locationTitleLabel.text = vm.title
    locationDescription.text = vm.locationDescription
    let radius = CGSize(width: UIConstants.CornerRadius.contentView,
                        height: UIConstants.CornerRadius.contentView)
    separatorView.alpha = 1.0
    let path: UIBezierPath
    switch vm.presentationStyle {
    case .top:
      path = UIBezierPath(roundedRect: bounds,
                              byRoundingCorners:[.topRight, .topLeft],
                              cornerRadii: radius)
    case .bottom:
      path = UIBezierPath(roundedRect: bounds,
                              byRoundingCorners:[.bottomRight, .bottomLeft],
                              cornerRadii: radius)
      separatorView.alpha = 0.0
    case .defaultStyle:
      layer.mask = nil
      return
    }
    
    let maskLayer = CAShapeLayer()
    maskLayer.path = path.cgPath
    layer.mask = maskLayer
  }
}

fileprivate enum UIConstants {
  enum CornerRadius {
    static let image: CGFloat = 5.0
    static let contentView: CGFloat = 10.0
    
  }
}
