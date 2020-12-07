//
//  BannedUserProfileContentViewController.swift
//  Pibble-iOS
//
//  Created by Sergey Kazakov on 31/05/2019.
//Copyright © 2019 com.kazai. All rights reserved.
//

import UIKit

//MARK: BannedUserProfileContentView Class
final class BannedUserProfileContentViewController: ViewController {
  
  @IBOutlet weak var scrollView: UIScrollView!
  @IBOutlet weak var wallImageView: UIImageView!
  
  @IBOutlet weak var avatarImageView: UIImageView!
  @IBOutlet weak var usernameLabel: UILabel!
  
  @IBOutlet weak var userStatusLabel: UILabel!
  
}

//MARK: - BannedUserProfileContentView API
extension BannedUserProfileContentViewController: BannedUserProfileContentViewControllerApi {
  func setBannedAccountViewModel(_ vm: BannedUserProfileContentAccountViewModelProtocol) {
    wallImageView.image = vm.wallPlaceholder
    wallImageView.setCachedImageOrDownload(vm.wallURLString)
    
    avatarImageView.image = vm.avatarPlaceholder
    avatarImageView.setCachedImageOrDownload(vm.avatarURLString)
   
    avatarImageView.setCornersToCircle()
    avatarImageView.layer.borderWidth = UIConstants.avatarImageViewBorderWidth
    avatarImageView.layer.borderColor = UIConstants.Colors.avatarImageViewBorder.cgColor
    
    usernameLabel.text = vm.username
    userStatusLabel.text = vm.blockStatus
    userStatusLabel.textColor = vm.blockStatusColor
  }
  
}

// MARK: - BannedUserProfileContentView Viper Components API
fileprivate extension BannedUserProfileContentViewController {
  var presenter: BannedUserProfileContentPresenterApi {
    return _presenter as! BannedUserProfileContentPresenterApi
  }
}


fileprivate enum UIConstants {
  static let avatarImageViewBorderWidth: CGFloat = 5.0
  
  enum Colors {
    static let avatarImageViewBorder = UIColor.white
  }
}
