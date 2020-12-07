//
//  PostsFeedPromotionPostPreviewViewController.swift
//  Pibble
//
//  Created by Sergey Kazakov on 08/06/2019.
//  Copyright © 2019 com.kazai. All rights reserved.
//

import UIKit

class PostsFeedPromotionPostPreviewViewController: PostsFeedViewController {
  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.refreshControl = nil
  }
}
