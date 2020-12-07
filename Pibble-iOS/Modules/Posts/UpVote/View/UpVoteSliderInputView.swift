//
//  UpVoteSliderInputView.swift
//  Pibble
//
//  Created by Kazakov Sergey on 09.01.2019.
//  Copyright © 2019 com.kazai. All rights reserved.
//

import UIKit

class UpVoteSliderInputView: NibLoadingView {
  //MARK:- IBOutlets
  
  @IBOutlet fileprivate weak var inputsContainerView: UIView!
  
  @IBOutlet fileprivate weak var upVoteIconImageView: UIImageView!
  @IBOutlet fileprivate weak var upVoteTitleLabel: UILabel!
  @IBOutlet fileprivate weak var currencyLabel: UILabel!
  @IBOutlet fileprivate weak var currencyAmountLabel: UILabel!
  @IBOutlet fileprivate weak var slider: UISlider!
  
  @IBOutlet fileprivate weak var minButton: UIButton!
  @IBOutlet fileprivate weak var maxButton: UIButton!
  
 
  //MARK:- IBActions
  
  @IBAction func directInputAction(_ sender: Any) {
    delegate?.handleDirectInputAction()
  }
  
  
  @IBAction fileprivate func sliderEndEditAction(_ sender: Any) {
    sliderEndEditBlock?()
  }
  
  @IBAction fileprivate func sliderValueChanged(_ sender: Any) {
    delegate?.handleChangeValue(slider.value)
  }
  
  @IBAction fileprivate func minAction(_ sender: Any) {
    delegate?.handleChangeValueToMin()
    sliderEndEditBlock?()
  }
  
  @IBAction fileprivate func maxAction(_ sender: Any) {
    delegate?.handleChangeValueToMax()
    sliderEndEditBlock?()
  }
  
  //MARK:- Delegate
  
  weak var delegate: UpVoteSliderInputViewDelegateProtocol?
  
  //MARK:- Private properties
  
  fileprivate var sliderEndEditBlock: (() -> Void)?
 
  //MARK:- Overrides
  
  override func setupView() {
    [minButton, maxButton].forEach {
      $0?.layer.cornerRadius =  ($0?.bounds.height ?? 0.0) * 0.5
      $0?.clipsToBounds = true
      $0?.layer.borderWidth = 1.0
      $0?.layer.borderColor = UIConstants.Colors.minmaxButtonsBorder.cgColor
    }
  }
  
  //MARK:- Public methods
  
  func setViewModel(_ vm: UpVote.UpVoteViewModel, animated: Bool) {
    slider.minimumValue = vm.minSliderValue
    slider.maximumValue = vm.maxSliderValue
    currencyAmountLabel.text = vm.currentUpVoteAmount
    currencyLabel.text = vm.currentUpVoteCurrency
    
    if !animated {
      slider.setValue(vm.currentSliderValue, animated: false)
    }
    
    sliderEndEditBlock = { [weak self] in
      self?.setSliderToValue(vm.currentSliderValue)
    }
  }
}

//MARK:- Helpers

extension UpVoteSliderInputView {
  fileprivate func setSliderToValue(_ value: Float) {
    UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.0, options: .curveEaseOut, animations: { [weak self] in
      guard let strongSelf = self else {
        return
      }
      
      strongSelf.slider.setValue(value, animated: true)
      
      }, completion: { (finish) in })
  }
}

//MARK:- UIConstants

fileprivate enum UIConstants {
  enum Colors {
    static let minmaxButtonsBorder = UIColor.gray112
  }
}
