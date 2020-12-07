//
//  CommentsHeaderFooterView.swift
//  Pibble
//
//  Created by Sergey Kazakov on 17/03/2019.
//  Copyright © 2019 com.kazai. All rights reserved.
//

import UIKit

typealias CommentHeaderActionHandler = (CommentsHeaderView, Comments.Actions) -> Void


class CommentsHeaderView: NibLoadingView {
  @IBOutlet var contentView: UIView!
  
  @IBOutlet weak var userImageView: UIImageView!
  @IBOutlet weak var bodyLabel: UILabel!
   @IBOutlet weak var dateLabel: UILabel!
 
  @IBAction func showUserAction(_ sender: Any) {
    handler?(self, .showUser)
  }
  
  fileprivate var handler: CommentHeaderActionHandler?
  
  override func setupView() {
    super.setupView()
    userImageView.setCornersToCircle()
    
    layer.shouldRasterize = true
    layer.rasterizationScale = UIScreen.main.scale
  }
  
  func setViewModel(_ vm: CommentsHeaderViewModelProtocol, handler: @escaping CommentHeaderActionHandler) {
    self.handler = handler
    userImageView.image = vm.userpicPlaceholder
    userImageView.setCachedImageOrDownload(vm.userPic)
    bodyLabel.attributedText = vm.attrubutedBody
    dateLabel.text = vm.date
  }
}

