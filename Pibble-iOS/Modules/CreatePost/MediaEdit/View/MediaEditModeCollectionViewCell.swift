//
//  MediaEditModeCollectionViewCell.swift
//  Pibble
//
//  Created by Kazakov Sergey on 13.07.2018.
//  Copyright © 2018 com.kazai. All rights reserved.
//

import UIKit

class MediaEditModeCollectionViewCell: UICollectionViewCell {
  static let identifier = "MediaEditModeCollectionViewCell"
   
  @IBOutlet weak var editModeImageView: UIImageView!
  func setViewModel(_ vm: MediaEditModeViewModel) {
    editModeImageView.image = vm.image
  }
}
