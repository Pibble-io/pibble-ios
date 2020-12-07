//
//  PostingMediaItemCollectionViewCell.swift
//  Pibble
//
//  Created by Kazakov Sergey on 13.07.2018.
//  Copyright © 2018 com.kazai. All rights reserved.
//

import UIKit

class PostingMediaItemCollectionViewCell: UICollectionViewCell {
  static let identifier = "PostingMediaItemCollectionViewCell"
  @IBOutlet weak var mediaImageView: UIImageView!
  
  var indexPath: IndexPath?
  
  func setViewModel(_ vm: MediaPostingMediaAttachmentViewModelProtocol) {
    mediaImageView.image = vm.image
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
    contentView.clipsToBounds = true
    contentView.layer.cornerRadius = UIConstants.cornerRadius
//    addShadow(shadowColor: .black,
//                   offSet: CGSize(width: 0, height: 0),
//                   opacity: 0.3, radius: 20)
    
  }
    
}

fileprivate enum UIConstants {
  static let cornerRadius: CGFloat = 5.0
  
}
