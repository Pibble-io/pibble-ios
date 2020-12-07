//
//  PostsFeedAllCommentsActionCollectionViewCell.swift
//  Pibble
//
//  Created by Kazakov Sergey on 02.08.2018.
//  Copyright © 2018 com.kazai. All rights reserved.
//

import UIKit

typealias PostsFeedAllCommentsActionTableViewCellActionHandler = (PostsFeedAllCommentsActionTableViewCell) -> Void


class PostsFeedAllCommentsActionTableViewCell: UITableViewCell, DequeueableCell {
  @IBOutlet weak var viewAllButton: UIButton!
    
  @IBAction func viewAllAction(_ sender: Any) {
    actionHandler?(self)
  }
  
  fileprivate var actionHandler: PostsFeedAllCommentsActionTableViewCellActionHandler?
  
  override func awakeFromNib() {
    super.awakeFromNib()
    layer.shouldRasterize = true
    layer.rasterizationScale = UIScreen.main.scale    
  }
  
  func setViewModel(_ vm: PostsFeedAllCommentsViewModelProtocol, actionHandler: @escaping PostsFeedAllCommentsActionTableViewCellActionHandler) {
    viewAllButton.setTitleForAllStates(vm.showAllCommentsTitle)
    viewAllButton.isHidden = !vm.shouldPresentShowAllTitle
    self.actionHandler = actionHandler
  }
}


