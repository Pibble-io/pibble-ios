//
//  PostsFeedContentViewController.swift
//  Pibble
//
//  Created by Sergey Kazakov on 11/06/2019.
//  Copyright © 2019 com.kazai. All rights reserved.
//

import UIKit

class PostsFeedContentViewController: PostsFeedBaseContentViewController {
  @IBOutlet weak var placeholderCreateDigitalGoodButton: UIButton!
  @IBOutlet weak var placeHolderBackgroundView: UIView!
  
  @IBOutlet weak var placeholderImageView: UIImageView!
  @IBOutlet weak var placeholderTitleLabel: UILabel!
  @IBOutlet weak var placeholderSubtitleLabel: UILabel!
 
  @IBAction func createDigitalGoodPostAction(_ sender: Any) {
    presenter.createDigitalGoodPostAction()
  }
  
  override func showPlaceholder(_ vm: PostsFeedItemsPlaceholderProtocol?, animated: Bool) {
    guard let vm = vm else {
      guard animated else {
        placeHolderBackgroundView.alpha = 0.0
        placeHolderBackgroundView.isHidden = true
        return
      }
      
      UIView.animate(withDuration: 0.3, animations: { [weak self] in
        self?.placeHolderBackgroundView.alpha = 0.0
      }) { [weak self] (_) in
        self?.placeHolderBackgroundView.isHidden = true
      }
      
      return
    }
    
    placeholderImageView.image = vm.image
    placeholderTitleLabel.text = vm.title
    placeholderSubtitleLabel.text = vm.subTitle
    placeholderCreateDigitalGoodButton.isHidden = !vm.isCreateButtonEnabled
    
    placeholderCreateDigitalGoodButton.setCornersToCircleByHeight()
    
    guard animated else {
      placeHolderBackgroundView.alpha = 1.0
      placeHolderBackgroundView.isHidden = false
      return
    }
    
    placeHolderBackgroundView.isHidden = false
    UIView.animate(withDuration: 0.3, animations: { [weak self] in
      self?.placeHolderBackgroundView.alpha = 1.0
    }) { (_) in
      
    }
  }
}
