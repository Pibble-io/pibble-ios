//
//  AboutHomeTableViewCell.swift
//  Pibble
//
//  Created by Kazakov Sergey on 05.10.2018.
//  Copyright © 2018 com.kazai. All rights reserved.
//

import UIKit

typealias AboutHomeTableViewCellSelectionHandler = (AboutHomeTableViewCell) -> Void

class AboutHomeTableViewCell: UITableViewCell, DequeueableCell {
  @IBOutlet weak var settingsItemImageView: UIImageView!
  @IBOutlet weak var settingsItemTitleLabel: UILabel!
  
  @IBOutlet weak var backgroundContainerView: UIView!
  @IBOutlet weak var blurView: UIVisualEffectView!
  
  fileprivate var handler: AboutHomeTableViewCellSelectionHandler?
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
    backgroundContainerView.clipsToBounds = true
    backgroundContainerView.layer.cornerRadius = backgroundContainerView.bounds.height * 0.5
  }
  
  @IBAction func touchUpAction(_ sender: Any) {
    anitamteScaleHighlighted(false)
    handler?(self)
  }
  
  @IBAction func touchDownAction(_ sender: Any) {
     anitamteScaleHighlighted(true)
  }
  
  func anitamteScaleHighlighted(_ highlighted: Bool) {
    let scale: CGFloat = highlighted ? 0.85: 1.0
    let viewToScale = backgroundContainerView
    
    UIView.animate(withDuration: 0.15, animations: {
      viewToScale?.transform = CGAffineTransform(scaleX: scale, y: scale)
    }) { (_) in
      
    }
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }
  
  func setViewModel(_ vm: AboutHomeItemViewModelProtocol, handler: @escaping AboutHomeTableViewCellSelectionHandler) {
    self.handler = handler
    settingsItemImageView.image = vm.image
    settingsItemTitleLabel.text = vm.title
    blurView.isHidden = vm.isActive
  }
  
}
