//
//  UpvotedUsersTableViewCell.swift
//  Pibble-iOS
//
//  Created by Sergey Kazakov on 24/07/2019.
//  Copyright © 2019 com.kazai. All rights reserved.
//

import UIKit


class UpvotedUsersTableViewCell: UITableViewCell, DequeueableCell {
  @IBOutlet weak var upvoteContainerView: UIView!
  
  @IBOutlet weak var userpicImageView: UIImageView!
  @IBOutlet weak var usernameLabel: UILabel!
  @IBOutlet weak var upvoteAmountLabel: UILabel!
  
  @IBOutlet weak var upvoteBackContainerView: UIView!
  
  @IBOutlet weak var upvoteBackAmountLabel: UILabel!
  
  @IBOutlet weak var followButton: UIButton!
  
  @IBOutlet weak var upvoteBackContainerViewWidthConstraint: NSLayoutConstraint!
  
  
  
  @IBAction func followAction(_ sender: Any) {
    handler?(self, .follow)
  }
  
  @IBAction func showUserAction(_ sender: Any) {
    handler?(self, .showUser)
  }
  
  @objc func doubleTapHandler(_ sender: UITapGestureRecognizer) {
   handler?(self, .upvoteInPlace)
  }
  
  @objc func tapHandler(_ sender: UITapGestureRecognizer) {
     handler?(self, .upvote)
  }
  
  //MARK:- private properties
  
  fileprivate lazy var doubleTapGestureRecognizer: UITapGestureRecognizer = {
    let gesture = UITapGestureRecognizer(target: self, action: #selector(doubleTapHandler(_:)))
    gesture.delegate = self
    gesture.numberOfTapsRequired = 2
    return gesture
  }()
  
  fileprivate lazy var tapGestureRecognizer: UITapGestureRecognizer = {
    let gesture = UITapGestureRecognizer(target: self, action: #selector(tapHandler(_:)))
    gesture.delegate = self
    gesture.numberOfTapsRequired = 1
    
    gesture.require(toFail: doubleTapGestureRecognizer)
    
    return gesture
  }()
  
  fileprivate var handler: UpvotedUsers.UpvotedUserItemsActionHandler?
  
  override func awakeFromNib() {
    super.awakeFromNib()
    layer.shouldRasterize = true
    layer.rasterizationScale = UIScreen.main.scale
    
    upvoteContainerView.addGestureRecognizer(doubleTapGestureRecognizer)
    upvoteContainerView.addGestureRecognizer(tapGestureRecognizer)
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }
  
  func setViewModel(_ vm: UpvotedUserViewModelProtocol, handler: @escaping UpvotedUsers.UpvotedUserItemsActionHandler) {
    self.handler = handler
    
    userpicImageView.image = vm.usrepicPlaceholder
    userpicImageView.setCachedImageOrDownload(vm.userpicUrlString) 
    
    usernameLabel.text = vm.username
    upvoteAmountLabel.text = vm.upvotedAmount
    
    followButton.setTitleForAllStates(vm.followingTitle)
    followButton.layer.borderWidth = 1.0
    
    upvoteContainerView.setCornersToCircleByHeight()
    userpicImageView.setCornersToCircleByHeight()
    followButton.setCornersToCircleByHeight()
    upvoteBackContainerView.setCornersToCircleByHeight()
    
    upvoteBackAmountLabel.text = vm.upvoteBackAmount
    upvoteBackContainerView.alpha = vm.isUpvoteBackVisible ? 1.0 : 0.0
    upvoteBackContainerViewWidthConstraint.constant = vm.isUpvoteBackVisible ? UIConstants.Constraints.upvoteBackContainerViewWidthConstraint :
      0.0
    
    followButton.isHidden = !vm.isFollowButtonVisible
    
    if vm.isFollowButtonHighlighted {
      followButton.setTitleColor(UIConstants.FollowButton.HighlightedState.titleColor, for: .normal)
      followButton.backgroundColor = UIConstants.FollowButton.HighlightedState.backgroundColor
      followButton.layer.borderColor = UIConstants.FollowButton.HighlightedState.borderColor.cgColor
    } else {
      followButton.setTitleColor(UIConstants.FollowButton.UnhighlightedState.titleColor, for: .normal)
      followButton.backgroundColor = UIConstants.FollowButton.UnhighlightedState.backgroundColor
      followButton.layer.borderColor = UIConstants.FollowButton.UnhighlightedState.borderColor.cgColor
    }
  }
}

fileprivate enum UIConstants {
  enum Constraints {
    static let upvoteBackContainerViewWidthConstraint: CGFloat = 53
  }
  
  enum FollowButton {
    enum HighlightedState {
      static let borderColor = UIColor.gray240
      static let backgroundColor = UIColor.white
      static let titleColor = UIColor.black
    }
    
    enum UnhighlightedState {
      static let borderColor = UIColor.bluePibble
      static let backgroundColor = UIColor.bluePibble
      static let titleColor = UIColor.white
    }
  }
}
