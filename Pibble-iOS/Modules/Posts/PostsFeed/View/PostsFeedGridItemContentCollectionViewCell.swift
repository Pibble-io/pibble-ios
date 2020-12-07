//
//  PostsFeedGridItemContentCollectionViewCell.swift
//  Pibble
//
//  Created by Kazakov Sergey on 23.11.2018.
//  Copyright © 2018 com.kazai. All rights reserved.
//

import UIKit

class PostsFeedGridItemContentCollectionViewCell: UICollectionViewCell, DequeueableCell {

  @IBOutlet weak var contentTypeIcon: UIImageView!
  
  @IBOutlet weak var contentImageView: UIImageView!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    layer.shouldRasterize = true
    layer.rasterizationScale = UIScreen.main.scale
  }
  
  func setViewModel(_ vm: PostsFeedContentViewModelProtocol) {
    contentTypeIcon.image = nil
    contentImageView.image = nil
    
    guard let first = vm.content.first else {
      return
    }
    
    switch first {
    case .image(let content):
      contentTypeIcon.image = nil
      contentImageView.setCachedImageOrDownload(content.urlString)
    case .video(let content):
      contentTypeIcon.image = #imageLiteral(resourceName: "PostsFeed-VideoGridIcon")
      contentImageView.setCachedImageOrDownload(content.thumbnailImageUrlString)
    }
    
    if vm.content.count > 1 {
      contentTypeIcon.image = #imageLiteral(resourceName: "PostsFeed-MultipleItemsGridIcon")
    }
  }
}
