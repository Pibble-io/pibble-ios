//
//  PostingMediaItemReusableView.swift
//  Pibble
//
//  Created by Kazakov Sergey on 20.08.2018.
//  Copyright © 2018 com.kazai. All rights reserved.
//

import UIKit

typealias PostingMediaItemReusableViewAddItemActionHandler = (PostingMediaItemReusableView) -> Void

class PostingMediaItemReusableView: UICollectionReusableView, DequeueableView {
  static let identifier = "PostingMediaItemReusableView"
  var actionHandler: PostingMediaItemReusableViewAddItemActionHandler?
  
  @IBAction func addItemAction(_ sender: Any) {
    actionHandler?(self)
  }
}
