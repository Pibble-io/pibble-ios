//
//  PostsFeedPhotoContentCollectionViewCell.swift
//  Pibble
//
//  Created by Kazakov Sergey on 02.08.2018.
//  Copyright © 2018 com.kazai. All rights reserved.
//

import UIKit

class PostsFeedImageContentCollectionViewCell: UICollectionViewCell, DequeueableCell, UIGestureRecognizerDelegate {
  @IBOutlet weak var contentImageView: UIImageView!

  fileprivate var itemLayout: PostsFeed.ItemLayout =  PostsFeed.ItemLayout.defaultLayout()
  fileprivate var isZooming = false
  fileprivate var originalImageCenter:CGPoint?
  
  override func awakeFromNib() {
    super.awakeFromNib()
    layer.shouldRasterize = true
    layer.rasterizationScale = UIScreen.main.scale
  }
  
  func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
    return true
  }
  
  func setViewModel(_ vm: PostsFeedImageViewModelProtocol, layout: PostsFeed.ItemLayout) {
    contentImageView.image = #imageLiteral(resourceName: "Nav-bar-pibble")
    contentImageView.setCachedImageOrDownload(vm.urlString)
    self.itemLayout = layout
  }
}

