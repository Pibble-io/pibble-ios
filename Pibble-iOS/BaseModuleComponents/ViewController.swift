//
//  ViewController.swift
//  Pibble
//
//  Created by Kazakov Sergey on 14.01.2019.
//  Copyright © 2019 com.kazai. All rights reserved.
//

import UIKit

class ViewController: BaseViewController {
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    fireViewDidAppearGlobalNotification()
  }
}


extension ViewController {
  func showAlertWith(_ title: String?, message: String?, actions: [UIAlertAction], preferredStyle: UIAlertController.Style) {
    let alertController = UIAlertController(title: title, message: message, safelyPreferredStyle: preferredStyle)
    
    alertController.view.tintColor = UIColor.bluePibble
    
    actions.forEach {
      alertController.addAction($0)
    }
    
    present(alertController, animated: true, completion: nil)
    alertController.view.tintColor = UIColor.bluePibble
  }
}
