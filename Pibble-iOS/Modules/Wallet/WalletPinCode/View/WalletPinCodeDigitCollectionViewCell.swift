//
//  WalletPinCodeDigitCollectionViewCell.swift
//  Pibble
//
//  Created by Kazakov Sergey on 12.09.2018.
//  Copyright © 2018 com.kazai. All rights reserved.
//

import UIKit

typealias WalletPinCodeDigitActionHandler = (WalletPinCodeDigitCollectionViewCell) -> Void

class WalletPinCodeDigitCollectionViewCell: UICollectionViewCell, DequeueableCell {
  fileprivate var handler: WalletPinCodeDigitActionHandler?

  @IBOutlet weak var digitLabel: UILabel!
  @IBOutlet weak var digitBackgroundView: UIView!
  
  @IBAction func digitDragOutsideAction(_ sender: Any) {
    let scale: CGFloat = 1.0
    let viewToScale = digitBackgroundView
    
    UIView.animate(withDuration: 0.15, animations: {
      viewToScale?.transform = CGAffineTransform(scaleX: scale, y: scale)
    }) { (_) in
      
    }
  }
  
  @IBAction func digitTouchDownAction(_ sender: Any) {
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
    handler?(self)
    
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
  
  func setViewModel(_ vm: DigitViewModelProtocol, handler: @escaping WalletPinCodeDigitActionHandler) {
    digitLabel.text = vm.title
    self.handler = handler
  }
}
