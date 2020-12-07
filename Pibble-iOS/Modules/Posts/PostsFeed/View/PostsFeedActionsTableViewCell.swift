//
//  PostsFeedActionsCollectionViewCell.swift
//  Pibble
//
//  Created by Kazakov Sergey on 02.08.2018.
//  Copyright © 2018 com.kazai. All rights reserved.
//

import UIKit
 
class PostsFeedActionsTableViewCell: UITableViewCell, DequeueableCell {
  @IBOutlet weak var favouritesButton: UIButton!
  
  @IBOutlet weak var likesCountLabel: AnimatedLabel!
  
  @IBOutlet weak var likeImageView: UIImageView!
  @IBOutlet weak var likeGestureView: UIView!
  
  @IBOutlet weak var likesTitleLabel: UILabel!
  
  @IBOutlet weak var winAmountContainerView: UIView!
  
  @IBOutlet weak var winAmountLabel: UILabel!
  
  @IBOutlet weak var postHelpRequestAmountContainerView: UIView!
  @IBOutlet weak var postHelpIconTriangularView: UIView!
  @IBOutlet weak var postHelpAmountBackgroundView: UIView!
  
  @IBOutlet weak var postHelpRewardLabel: UILabel!
  
  
  @IBAction func favoritesAction(_ sender: Any) {
    actionHandler?(self, .favorites)
  }
  
  @IBAction func helpAction(_ sender: Any) {
    actionHandler?(self, .help)
  }
  
  @IBAction func commentAction(_ sender: Any) {
    actionHandler?(self, .comment)
  }
  
  @IBAction func shopAction(_ sender: Any) {
    actionHandler?(self, .shop)
  }
  
  fileprivate var actionHandler: PostsFeed.ActionsTableViewCellHandler?
  fileprivate var isLikeActionPerformed: Bool = false
  
  fileprivate lazy var doubleTapGestureRecognizer: UITapGestureRecognizer = {
    let gesture = UITapGestureRecognizer(target: self, action: #selector(upvotesUsersDoubleTapAction))
    gesture.delegate = self
    gesture.numberOfTapsRequired = 2
    return gesture
  }()
  
  fileprivate lazy var tapGestureRecognizer: UITapGestureRecognizer = {
    let gesture = UITapGestureRecognizer(target: self, action: #selector(upvotesUsersTapAction))
    gesture.delegate = self
    gesture.numberOfTapsRequired = 1
    
    gesture.require(toFail: doubleTapGestureRecognizer)
    
    return gesture
  }()
  
  fileprivate lazy var longTapGestureRecognizer: UILongPressGestureRecognizer = {
    let gesture = UILongPressGestureRecognizer(target: self, action: #selector(self.upvotesUsersLongTapAction))
    gesture.delegate = self
    
    return gesture
  }()
  
  override func awakeFromNib() {
    super.awakeFromNib()
    layer.shouldRasterize = true
    layer.rasterizationScale = UIScreen.main.scale
    
    likeGestureView.addGestureRecognizer(longTapGestureRecognizer)
    likeGestureView.addGestureRecognizer(tapGestureRecognizer)
    likeGestureView.addGestureRecognizer(doubleTapGestureRecognizer)
    
    winAmountContainerView.setCornersToCircleByHeight()
    
    postHelpIconTriangularView.transform = CGAffineTransform(rotationAngle: CGFloat.pi / 4.0)
    postHelpIconTriangularView.layer.cornerRadius = 2.0
    postHelpIconTriangularView.clipsToBounds = true
    
    postHelpAmountBackgroundView.layer.cornerRadius = 2.0
    postHelpAmountBackgroundView.clipsToBounds = true
  }
  
  @objc func upvotesUsersLongTapAction(gesture: UILongPressGestureRecognizer) {
    actionHandler?(self, .upvotedUsers)
  }
  
  @objc func upvotesUsersDoubleTapAction(gesture: UILongPressGestureRecognizer) {
    actionHandler?(self, .upvotedUsers)
  }
  
  @objc func upvotesUsersTapAction(gesture: UILongPressGestureRecognizer) {
    animateLikeButtonAction()
    actionHandler?(self, .upvote)
  }
  
  func setViewModel(_ vm: PostsFeedActionsViewModelProtocol, actionHandler: @escaping PostsFeed.ActionsTableViewCellHandler) {
    
    self.actionHandler = actionHandler
    
    
    let favoritesButtonNormatStateImage = vm.isCollectPromoted ?
          UIImage(imageLiteralResourceName: "PostsFeed-FavoritesButton-promoted") :
          UIImage(imageLiteralResourceName: "PostsFeed-FavouritesButton")
    let favouritesImage = vm.isAddedToFavorites ?
      UIImage(imageLiteralResourceName: "PostsFeed-FavouritesButton-active"):
      favoritesButtonNormatStateImage
    
    favouritesButton.setImage(favouritesImage, for: .normal)
   
    let likesButtonNormatStateImage = vm.isUpvotePromoted ?
      UIImage(imageLiteralResourceName: "PostsFeed-LikesButton-promoted"):
      UIImage(imageLiteralResourceName: "PostsFeed-LikesButton")
    
    let likeButtonImage = vm.isLiked ?
      UIImage(imageLiteralResourceName: "PostsFeed-LikesButton-active"):
      likesButtonNormatStateImage
    
    likeImageView.image = likeButtonImage
    if vm.shouldAnimateLikesCount {
      animateLikeButtonAction(duration: 0.15, scale: 1.5, delay: 1.3)
      let duration = 1.0
      likesCountLabel.count(from: Float(vm.likesCountOldValue),
                            to: Float(vm.likesCount),
                            duration: duration)
    } else {
      likesCountLabel.text = String(vm.likesCount)
    }
    
    likesTitleLabel.text = vm.likesTitleString
    
    winAmountContainerView.isHidden = !vm.isWinAmountVisible
    winAmountLabel.text = vm.winAmount
    
    postHelpRequestAmountContainerView.isHidden = !vm.hasPostHelpRequest
    postHelpRewardLabel.text = vm.postHelpRequestReward
    
    [postHelpIconTriangularView, postHelpAmountBackgroundView].forEach {
      $0?.backgroundColor = vm.isPostHelpRequestActive ?
        UIConstants.Colors.postHelpActiveBackground:
        UIConstants.Colors.postHelpInActiveBackground
    }
  }
  
  func animateLikeButtonAction(duration: TimeInterval = 0.15, scale: CGFloat = 1.25, delay: TimeInterval = 0.0) {
    likeImageView.bubbleAnimate(duration: duration, scale: scale, delay: delay)
  }
}

fileprivate enum UIConstants {
  enum Colors {
    static let favourites = UIColor.gray28
    static let favouritesSelected = UIColor.pinkPibble
    
    static let postHelpActiveBackground = UIColor.yellowPostHelp
    static let postHelpInActiveBackground = UIColor.gray243
    
    
  }
}
