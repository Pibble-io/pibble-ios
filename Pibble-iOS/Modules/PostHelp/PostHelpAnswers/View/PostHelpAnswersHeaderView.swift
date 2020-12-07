//
//  PostHelpAnswersHeaderFooterView.swift
//  Pibble
//
//  Created by Sergey Kazakov on 17/03/2019.
//  Copyright © 2019 com.kazai. All rights reserved.
//

import UIKit

typealias PostHelpAnswersHeaderActionHandler = (PostHelpAnswersHeaderView, PostHelpAnswers.Actions) -> Void


class PostHelpAnswersHeaderView: NibLoadingView {
  @IBOutlet var contentView: UIView!
  
  @IBOutlet weak var userImageView: UIImageView!
  @IBOutlet weak var bodyLabel: UILabel!
   @IBOutlet weak var dateLabel: UILabel!
 
  @IBAction func showUserAction(_ sender: Any) {
    handler?(self, .showUser)
  }
  
  fileprivate var handler: PostHelpAnswersHeaderActionHandler?
  
  override func setupView() {
    super.setupView()
    userImageView.setCornersToCircle()
    
    layer.shouldRasterize = true
    layer.rasterizationScale = UIScreen.main.scale
  }
  
  func setViewModel(_ vm: PostHelpAnswersHeaderViewModelProtocol, handler: @escaping PostHelpAnswersHeaderActionHandler, animated: Bool) {
    self.handler = handler
    userImageView.image = vm.userpicPlaceholder
    userImageView.setCachedImageOrDownload(vm.userPic)
    
    dateLabel.text = vm.date
    
    guard animated else {
      bodyLabel.attributedText = vm.attrubutedBody
      return
    }
    
    bodyLabel.fadeTransition(0.3)
    bodyLabel.attributedText = vm.attrubutedBody
  }
}

