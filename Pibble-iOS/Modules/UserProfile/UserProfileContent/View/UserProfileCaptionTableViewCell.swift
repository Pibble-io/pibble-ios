//
//  UserProfileCaptionTableViewCell.swift
//  Pibble
//
//  Created by Kazakov Sergey on 06.11.2018.
//  Copyright © 2018 com.kazai. All rights reserved.
//

import UIKit

typealias UserProfileCaptionActionsHandler = (UserProfileCaptionTableViewCell, UserProfileContent.UserProfileCaptionActions) -> Void

class UserProfileCaptionTableViewCell: UITableViewCell, DequeueableCell {
  @IBOutlet weak var editCaptionButtonImageView: UIImageView!
  
  @IBOutlet weak var captionTitleLabel: UILabel!
  
  @IBOutlet weak var captionLabel: UILabel!
  
  @IBOutlet weak var websiteLabel: UILabel!
  
  @IBOutlet weak var showWebsiteButton: UIButton!
  @IBOutlet weak var websiteLabelBottomConstraint: NSLayoutConstraint!
  
  @IBAction func showWebsiteAction(_ sender: Any) {
    handler?(self, .showWebsite)
  }
  
  @IBAction func editCaptionAction(_ sender: Any) {
    handler?(self, .edit) 
  }
  
  fileprivate var handler: UserProfileCaptionActionsHandler?
  
  override func awakeFromNib() {
    super.awakeFromNib()
    layer.shouldRasterize = true
    layer.rasterizationScale = UIScreen.main.scale
  }
  
  func setViewModel(_ vm: UserProfileCaptionViewModelProtocol, handler: @escaping UserProfileCaptionActionsHandler) {
    self.handler = handler
    captionLabel.text = vm.caption
    captionLabel.textColor = vm.hasCaption ? UIConstants.Colors.hasCaptionTextColor : UIConstants.Colors.emptyCaptionTextColor
    editCaptionButtonImageView.isHidden = vm.isEditButtonHidden
    
    websiteLabelBottomConstraint.constant = vm.hasWebsite ?
      UIConstants.Constraints.websiteBottomConstraint :
      UIConstants.Constraints.websiteBottomZeroConstraint
    
//    websiteLabel.isHidden = !vm.hasWebsite
    websiteLabel.text = vm.website
  }
}

fileprivate enum UIConstants {
  enum Colors {
    static let hasCaptionTextColor = UIColor.gray78
    static let emptyCaptionTextColor = UIColor.gray213
  }
  
  enum Constraints {
    static let websiteBottomConstraint: CGFloat = 10
    static let websiteBottomZeroConstraint: CGFloat = 0
  }
}
