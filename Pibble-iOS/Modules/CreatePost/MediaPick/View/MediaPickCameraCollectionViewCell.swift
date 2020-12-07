//
//  MediaPickCameraCollectionViewCell.swift
//  Pibble
//
//  Created by Kazakov Sergey on 05.07.2018.
//  Copyright © 2018 com.kazai. All rights reserved.
//

import UIKit

class MediaPickCameraCollectionViewCell: UICollectionViewCell {
  static let identifier = "MediaPickCameraCollectionViewCell"
  
  @IBOutlet weak var cameraImageView: UIImageView!
  @IBOutlet weak var cameraSubtitleLabel: UILabel!
  
  func setViewModel(title: String) {
    cameraSubtitleLabel.text = title
  }
}
