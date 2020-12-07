//
//  PostsFeedUserPostsContentController.swift
//  Pibble
//
//  Created by Kazakov Sergey on 21.11.2018.
//  Copyright © 2018 com.kazai. All rights reserved.
//

import UIKit

class PostsFeedViewController: PostsFeedBaseContentViewController {
  //MARK:- IBActions
  @IBOutlet weak var navigationBarTitleLabel: UILabel!
  
  @IBOutlet weak var placeholderCreateDigitalGoodButton: UIButton!
  @IBOutlet weak var placeHolderBackgroundView: UIView!
  
  @IBOutlet weak var placeholderImageView: UIImageView!
  @IBOutlet weak var placeholderTitleLabel: UILabel!
  @IBOutlet weak var placeholderSubtitleLabel: UILabel!
    
  @IBAction func hideAction(_ sender: Any) {
    hideAction()
  }
  
  @IBAction func createDigitalGoodPostAction(_ sender: Any) {
    presenter.createDigitalGoodPostAction()
  }
  
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    navigationBarTitleLabel.text = presenter.navigationBarTitle
  }
  
  override func scrollTo(_ indexPath: IndexPath, animated: Bool) {
    tableView.scrollToRow(at: indexPath, at: .top, animated: animated)
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



