//
//  WalletPinCodeDigitControlCollectionViewCell.swift
//  Pibble
//
//  Created by Kazakov Sergey on 12.09.2018.
//  Copyright © 2018 com.kazai. All rights reserved.
//

import UIKit

typealias WalletPinCodeDigitControlActionHandler = (WalletPinCodeDigitControlCollectionViewCell, WalletPinCode.ControlActions) -> Void

class WalletPinCodeDigitControlCollectionViewCell: UICollectionViewCell, DequeueableCell {
  fileprivate var handler: WalletPinCodeDigitControlActionHandler?
  @IBOutlet weak var digitLabel: UILabel!
  
  @IBOutlet weak var leftButton: UIButton!
  @IBOutlet weak var rightButton: UIButton!
  @IBOutlet weak var digitBackgroundView: UIView!
  
  @IBAction func digitDragOutsideAction(_ sender: Any) {
    let scale: CGFloat = 1.0
    let viewToScale = digitBackgroundView
    
    UIView.animate(withDuration: 0.15, animations: {
      viewToScale?.transform = CGAffineTransform(scaleX: scale, y: scale)
    }) { (_) in
      
    }
  }
  @IBAction func digitTouchDown(_ sender: Any) {
    let scale: CGFloat = 0.9
    let viewToScale = digitBackgroundView
    
    UIView.animate(withDuration: 0.15, animations: {
      viewToScale?.transform = CGAffineTransform(scaleX: scale, y: scale)
    }) { (_) in
      
    }
  }
  
  override func draw(_ rect: CGRect) {
    digitBackgroundView.setCornersToCircle()
  }
  
  @IBAction func digitAction(_ sender: Any) {
    handler?(self, .digitSelect)
    
    let scale: CGFloat = 1.25
    let viewToScale = digitBackgroundView
    
    UIView.animate(withDuration: 0.15, animations: {
      viewToScale?.transform = CGAffineTransform(scaleX: scale, y: scale)
    }) { (_) in
      UIView.animate(withDuration: 0.15, animations: {
        viewToScale?.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
      }) { (_) in  }
    }
  }
  
  @IBAction func leftAction(_ sender: Any) {
     handler?(self, .left)
  }
  
  @IBAction func rightAction(_ sender: Any) {
    handler?(self, .right)
  }
  
  func setViewModel(_ vm: DigitWithControlsViewModelProtocol, handler: @escaping WalletPinCodeDigitControlActionHandler) {
    digitLabel.text = vm.title
    leftButton.setTitleForAllStates(vm.leftTitle)
    rightButton.setTitleForAllStates(vm.rightTitle)
    self.handler = handler 
  }
}
