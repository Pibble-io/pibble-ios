//
//  ChatRoomsForGroupViewController.swift
//  Pibble
//
//  Created by Sergey Kazakov on 13/04/2019.
//  Copyright © 2019 com.kazai. All rights reserved.
//

import UIKit

class ChatRoomsForGroupViewController: ChatRoomsViewController {
  
  //MARK:- IBOutlets
  
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var subtitleLabel: UILabel!
  
  
  
  //MARK:- Overrides
  
  override func setNavBarViewModel(_ vm: ChatRoomsNavigationBarViewModelProtocol) {
    titleLabel.text = vm.title
    subtitleLabel.text = vm.subtitle
  }
}


