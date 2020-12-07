//
//  MediaAlbumPickCollectionViewCell.swift
//  Pibble
//
//  Created by Kazakov Sergey on 12.12.2018.
//  Copyright © 2018 com.kazai. All rights reserved.
//

import UIKit

class MediaAlbumPickCollectionViewCell: UICollectionViewCell, DequeueableCell {
  @IBOutlet weak var albumTitleLabel: UILabel!
  @IBOutlet weak var albumPhotoCountLabel: UILabel!
  @IBOutlet weak var albumImageView: UIImageView!
  
  fileprivate var indexPath: IndexPath?
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
    layer.shouldRasterize = true
    layer.rasterizationScale = UIScreen.main.scale
  }
  
  func setViewModel(_ vm: MediaAlbumPickItemViewModelProtocol) {
    vm.previewImageRequest() { [weak self] image, idx  in
      if self?.indexPath == idx {
        self?.albumImageView.image = image
      }
    }
    albumImageView.image = nil
    indexPath = vm.indexPath
    albumPhotoCountLabel.text = vm.albumItemsCount
    albumTitleLabel.text = vm.albumTitle
  }
}
