//
//  LeaderboardHeaderView.swift
//  Pibble-iOS
//
//  Created by Sergey Kazakov on 20/07/2019.
//  Copyright © 2019 com.kazai. All rights reserved.
//

import UIKit


class LeaderboardHeaderView: NibLoadingView {
  @IBOutlet var contentView: UIView!
  
  @IBOutlet var userpicImageViews: [UIImageView]!
  
  @IBOutlet var usernameLabels: [UILabel]!
  @IBOutlet var valueLabels: [UILabel]!
  
  @IBOutlet var backgroundValuesViews: [UIView]!
  
  @IBOutlet var containerViews: [UIView]!
  
  @IBOutlet var userpicButtons: [UIButton]!
  
  @IBOutlet var prizeValueButtons: [UIButton]!
  
  @IBAction func prizeValueSelectAction(_ sender: UIButton) {
    guard let index = prizeValueButtons.firstIndex(of: sender) else {
      return
    }
    
    handler?(self, .showTopUserPosts(index))
  }
  
  @IBAction func selectAction(_ sender: UIButton) {
    guard let index = userpicButtons.firstIndex(of: sender) else {
      return
    }
    
    handler?(self, .showTopUser(index))
  }
  
  fileprivate var handler: LeaderboardContent.LeaderboardTopActionsHandler?
  
  override func setupView() {
    backgroundValuesViews.forEach {
      $0.setCornersToCircleByHeight()
    }
    
    userpicImageViews.forEach {
      $0.setCornersToCircleByHeight()
    }
    
    containerViews.forEach {
      $0.isHidden = true
    }
  }
  
  func setViewModel(_ viewModels: [LeaderboardEntryViewModelProtocol], handler: @escaping LeaderboardContent.LeaderboardTopActionsHandler) {
    self.handler = handler
    
    zip(containerViews, viewModels).forEach {
      $0.0.isHidden = false
    }
    
    viewModels.prefix(3).enumerated().forEach {
      userpicImageViews[$0.offset].image = $0.element.avatarPlaceholder
      userpicImageViews[$0.offset].setCachedImageOrDownload($0.element.avatarURLString)
      usernameLabels[$0.offset].text = $0.element.username
      valueLabels[$0.offset].text = $0.element.leaderboardValue
    }
  }
}
