//
//  UpvotedUserCollectionViewCell.swift
//  Pibble
//
//  Created by Kazakov Sergey on 28.09.2018.
//  Copyright © 2018 com.kazai. All rights reserved.
//

import UIKit

typealias UpvotedUserCollectionViewCellActionHandler = (UpvotedUserCollectionViewCell) -> Void

class UpvotedUserCollectionViewCell: UICollectionViewCell, DequeueableCell {
  @IBOutlet weak var userpicImageView: UIImageView!
  @IBOutlet weak var upvoteAmountLabel: UILabel!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    isUserInteractionEnabled = true
    addGestureRecognizer(longPress)
    UIView.performWithoutAnimation { [weak self] in
      self?.userpicImageView.setCornersToCircle()
    }
  }
  
  
  fileprivate lazy var longPress: UILongPressGestureRecognizer = {
    let gesture = UILongPressGestureRecognizer(target: self, action: #selector(self.longPressHandler(gesture:)))
    return gesture
  }()
  
  @objc func longPressHandler(gesture: UILongPressGestureRecognizer) {
    if gesture.state == UIGestureRecognizer.State.began {
      handler?(self)
    }
  }
  
  fileprivate var handler: UpvotedUserCollectionViewCellActionHandler?
  
  func setViewModel(_ vm: UpvotedUserViewModelProtocol, handler: @escaping UpvotedUserCollectionViewCellActionHandler) {
    self.handler = handler
    userpicImageView.image = vm.usrepicPlaceholder
    userpicImageView.alpha = 0.0
    UIView.animate(withDuration: 0.2) { [weak self] in
      self?.userpicImageView.alpha = 1.0
    }
    userpicImageView.setCachedImageOrDownload(vm.userpicUrlString)
    upvoteAmountLabel.text = vm.upvotedAmount
  }
}

