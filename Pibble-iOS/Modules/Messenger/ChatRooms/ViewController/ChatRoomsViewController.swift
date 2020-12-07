//
//  ChatRoomsViewController.swift
//  Pibble
//
//  Created by Sergey Kazakov on 12/04/2019.
//  Copyright © 2019 com.kazai. All rights reserved.
//

import UIKit

class ChatRoomsViewController: ChatRoomsContentViewController {
  @IBAction func hideAction(_ sender: Any) {
    hideAction()
  }
  
  override var shouldHandleSwipeToPopGesture: Bool {
    return true
  }

}
