//
//  PromotionPickViewController.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 21.08.2018.
//Copyright © 2018 com.kazai. All rights reserved.
//

import UIKit

//MARK: PromotionPickView Class
final class PromotionPickViewController: ViewController {
  @IBOutlet weak var hideButton: UIButton!
  @IBOutlet weak var doneButton: UIButton!
  
  @IBOutlet weak var budgetLabel: UILabel!
  @IBOutlet weak var budgetCurrencyLabel: UILabel!
  
  @IBOutlet weak var promotionInfoLabel: UILabel!
  @IBOutlet weak var budgetSlider: UISlider!
  @IBOutlet weak var currentBalanceInfoLabel: UILabel!
  
  @IBOutlet weak var likeButton: UIButton!
  
  @IBOutlet weak var shareButton: UIButton!
  
  @IBOutlet weak var collectButton: UIButton!
  
  @IBOutlet weak var tagButton: UIButton!
  
  @IBOutlet weak var likeLabel: UILabel!
  @IBOutlet weak var shareLabel: UILabel!
  
  @IBOutlet weak var collectLabel: UILabel!
  
  @IBOutlet weak var tagLabel: UILabel!
  
  @IBOutlet weak var budgetTextField: UITextField!
  @IBOutlet weak var budgetTextFieldTrailingConstraint: NSLayoutConstraint!
  
  @IBAction func showTextFieldAction(_ sender: Any) {
    setTextFieldPresentation(false, animated: true)
  }
  
  @IBAction func budgetTextFieldEditChange(_ sender: UITextField) {
    //presenter.handleBudgetChange(sender.text ?? "")
  }
  
  @IBAction func hideAction(_ sender: Any) {
    presenter.handleHideAction()
  }
  
  @IBAction func doneAction(_ sender: Any) {
    presenter.handleDoneAction()
  }
  
  @IBAction func activitySelectAction(_ sender: UIButton) {
    if sender == likeButton {
      presenter.handleActivitySelectionChange(.like)
    }
    
    if sender == shareButton {
      presenter.handleActivitySelectionChange(.share)
    }
    
    if sender == collectButton {
      presenter.handleActivitySelectionChange(.collect)
    }
    
    if sender == tagButton {
      presenter.handleActivitySelectionChange(.tag)
    }
  }
  
  @IBAction func budgetSliderValueChangedAction(_ sender: Any) {
    presenter.handleBudgetChange(Double(budgetSlider.value))
  }
  
  @IBAction fileprivate func sliderEndEditAction(_ sender: Any) {
    sliderEndEditBlock?()
  }
  
  //MARK:- Private properties
  
  fileprivate var sliderEndEditBlock: (() -> Void)?
  
  
  //MARK:- Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupView()
    setupAppearance()
    setTextFieldPresentation(true, animated: false)
  }
}

//MARK: - PromotionPickView API
extension PromotionPickViewController: PromotionPickViewControllerApi {
  func setSliderViewModel(_ vm: PromotionPick.BudgetSliderViewModel, animated: Bool, delayed: Bool) {
    budgetSlider.maximumValue = vm.maxValue
    budgetSlider.minimumValue = vm.minValue
    
    guard delayed else {
      setSliderToValue(vm.currentValue, animated: animated)
      return
    }
    
    sliderEndEditBlock = { [weak self] in
      self?.setSliderToValue(vm.currentValue, animated: true)
    }
  }
  
  func setDoneButtonEnabled(_ enabled: Bool) {
    doneButton.isEnabled = enabled
  }
  
  func setBudgetLimits(min: Double, max: Double) {
    budgetSlider.maximumValue = Float(max)
    budgetSlider.minimumValue = Float(min)
  }

  func setCurrentBudget(_ value: String, currencySymbolValue: String) {
    budgetLabel.text = value
    budgetCurrencyLabel.text = currencySymbolValue
    
    let zeroValue = PromotionPick.Strings.zeroValue.localize()
    
    if zeroValue == value {
      budgetTextField.placeholder = zeroValue
      budgetTextField.text = ""
    } else {
      budgetTextField.text = value
    }
  }
  
  func setPromotionInfo(_ value: NSAttributedString) {
    promotionInfoLabel.attributedText = value
    view.setNeedsLayout()
    UIView.animate(withDuration: 0.3) { [weak self] in
      self?.view.layoutIfNeeded()
    }
  }
  
  func setCurrentBalanceInfo(_ value: NSAttributedString) {
    currentBalanceInfoLabel.attributedText = value
    view.setNeedsLayout()
    UIView.animate(withDuration: 0.3) { [weak self] in
      self?.view.layoutIfNeeded()
    }
  }
  
  func setActivitySelection(_ activity: PromotionPick.PromotionActivities, isSelected: Bool) {
    
    var button: UIButton? = nil
    
    switch activity {
    case .like:
      button = likeButton
      likeLabel.textColor = isSelected ? UIConstants.Colors.selectedColor : UIConstants.Colors.unselectedColor
    case .share:
      button = shareButton
      shareLabel.textColor = isSelected ? UIConstants.Colors.selectedColor : UIConstants.Colors.unselectedColor
    case .collect:
      button = collectButton
      collectLabel.textColor = isSelected ? UIConstants.Colors.selectedColor : UIConstants.Colors.unselectedColor
    case .tag:
      button = tagButton
      tagLabel.textColor = isSelected ? UIConstants.Colors.selectedColor : UIConstants.Colors.unselectedColor
    }
    
    guard let activityButton = button else {
      return
    }
    
    let shouldAnimate = activityButton.isSelected != isSelected
    activityButton.isSelected = isSelected
    
    guard shouldAnimate else {
      return
    }
    
    let scale: CGFloat = activityButton.isSelected ? 1.25 : 0.85
    
    UIView.animate(withDuration: 0.15, animations: {
      activityButton.transform = CGAffineTransform(scaleX: scale, y: scale)
    }) { (_) in
      UIView.animate(withDuration: 0.15, animations: {
        activityButton.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
      }) { (_) in  }
    }
  }
}

//MARK:- Helpers {
extension PromotionPickViewController {
  fileprivate func setSliderToValue(_ value: Float, animated: Bool) {
    guard animated else {
      budgetSlider.setValue(value, animated: false)
      return
    }
    
    UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.0, options: .curveEaseOut, animations: { [weak self] in
      guard let strongSelf = self else {
        return
      }
      
      strongSelf.budgetSlider.setValue(value, animated: true)
      
      }, completion: { (finish) in })
  }
  
  fileprivate func setTextFieldPresentation(_ hidden: Bool, animated: Bool) {
    if !hidden {
      budgetTextField.becomeFirstResponder()
    }
    
    budgetTextFieldTrailingConstraint.priority = hidden ? .defaultLow : .defaultHigh
    guard animated else {
      budgetTextField.alpha = hidden ? 0.0 : 1.0
      budgetLabel.alpha = !hidden ? 0.0 : 1.0
      budgetSlider.alpha = !hidden ? 0.0 : 1.0
      return
    }
    
    guard hidden else {
      UIView.animate(withDuration: 0.3, animations: { [weak self] in
        self?.view.layoutIfNeeded()
        self?.budgetSlider.alpha = !hidden ? 0.0 : 1.0
      }) { (_) in
        UIView.animate(withDuration: 0.3) { [weak self] in
          guard let strongSelf = self else {
            return
          }
          
          strongSelf.budgetTextField.alpha = hidden ? 0.0 : 1.0
          strongSelf.budgetLabel.alpha = !hidden ? 0.0 : 1.0
         
        }
      }
      return
    }
    
    budgetLabel.alpha = !hidden ? 0.0 : 1.0
    budgetTextField.alpha = hidden ? 0.0 : 1.0
    
    UIView.animate(withDuration: 0.3, animations: { [weak self] in
      guard let strongSelf = self else {
        return
      }
    
      strongSelf.budgetSlider.alpha = !hidden ? 0.0 : 1.0
      self?.view.layoutIfNeeded()
    }) { (_) in   }
    
  }
  
  fileprivate func setupView() {
    budgetSlider.isContinuous = true
    budgetTextField.delegate = self
    
    let keyboardDoneButtonView = UIToolbar()
    keyboardDoneButtonView.sizeToFit()
    let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
    
    let doneButton = UIBarButtonItem(barButtonSystemItem: .done,
                                     target: self,
                                     action: #selector(self.doneEditing))
    
    let attributes = [NSAttributedString.Key.font: UIFont.AvenirNextMedium(size: 17),
                      NSAttributedString.Key.foregroundColor: UIConstants.Colors.doneButton]
    
    doneButton.setTitleTextAttributes(attributes, for: .normal)
    doneButton.setTitleTextAttributes(attributes, for: .selected)
    doneButton.setTitleTextAttributes(attributes, for: .disabled)
    doneButton.setTitleTextAttributes(attributes, for: .highlighted)
    
    keyboardDoneButtonView.items = [space, doneButton]
    
    budgetTextField.inputAccessoryView = keyboardDoneButtonView
  }
  
  fileprivate func setupAppearance() {
    budgetTextField.layer.cornerRadius = UIConstants.CornerRadius.inputTextField
    budgetTextField.clipsToBounds = true
    budgetTextField.layer.borderColor = UIConstants.Colors.inputTextFieldBorder.cgColor
    budgetTextField.layer.borderWidth = 1.0
  }
  
  @objc func doneEditing() {
    budgetTextField.endEditing(true)
  }
}

// MARK: - PromotionPickView Viper Components API
fileprivate extension PromotionPickViewController {
  var presenter: PromotionPickPresenterApi {
    return _presenter as! PromotionPickPresenterApi
  }
}

extension PromotionPickViewController: UITextFieldDelegate {
  func textFieldDidEndEditing(_ textField: UITextField) {
    setTextFieldPresentation(true, animated: true)
    presenter.handleBudgetChange(textField.text ?? "")
    sliderEndEditBlock?()
  }
}

fileprivate enum UIConstants {
  enum Colors {
    static let selectedColor =  UIColor.pinkPibble
    static let unselectedColor =  UIColor.gray188
    
    static let doneButton = UIColor.bluePibble
    static let inputTextFieldBorder = UIColor.gray112
  }
  
  enum CornerRadius {
    static let inputTextField: CGFloat = 11
  }
}
