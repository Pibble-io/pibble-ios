//
//  DiscoverSearchContentResultTableViewCell.swift
//  Pibble
//
//  Created by Kazakov Sergey on 25.12.2018.
//  Copyright © 2018 com.kazai. All rights reserved.
//

import UIKit

typealias DiscoverSearchContentResultCopySearchStringActionHandler = (DiscoverSearchContentResultTableViewCell) -> Void


class DiscoverSearchContentResultTableViewCell: UITableViewCell, DequeueableCell {
  @IBOutlet weak var resultImageView: UIImageView!
  @IBOutlet weak var resultTitleLabel: UILabel!
  @IBOutlet weak var resultSubtitleLabel: UILabel!
   
  @IBOutlet weak var resultTypeImageView: UIImageView!
  
  @IBOutlet weak var copySearchStringButton: UIButton!
  
  @IBAction func copySearchStringAction(_ sender: Any) {
    handler?(self)
  }
  
  fileprivate var handler: DiscoverSearchContentResultCopySearchStringActionHandler?
  
  func setViewModel(_ vm: DiscoverSearchContentResultViewModelProtocol, handler: @escaping DiscoverSearchContentResultCopySearchStringActionHandler) {
    
    self.handler = handler
    copySearchStringButton.isHidden = !vm.isCopySearchStringAvailable
    
    resultImageView.setCornersToCircle()
    
    resultImageView.image = vm.resultImagePlaceholder
    resultImageView.setCachedImageOrDownload(vm.resultImage)
    
    resultTypeImageView.isHidden = vm.resultTypeImage == nil
    resultTypeImageView.image = vm.resultTypeImage
    
    resultTitleLabel.text = vm.resultTitle
    resultSubtitleLabel.text = vm.resultSubtitle
  }
}


