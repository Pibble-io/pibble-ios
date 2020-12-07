//
//  UIViewEndEditingExtension.swift
//  Pibble
//
//  Created by Kazakov Sergey on 27.07.2018.
//  Copyright © 2018 com.kazai. All rights reserved.
//

import UIKit

extension UIView {
  func addEndEditingTapGesture() {
    let gesture = UITapGestureRecognizer(target: self, action: #selector(self.forceEndEnditing))
    addGestureRecognizer(gesture)
  }
  
  @objc func forceEndEnditing() {
    endEditing(true)
  }
}


