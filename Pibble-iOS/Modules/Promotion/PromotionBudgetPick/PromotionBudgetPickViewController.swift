//
//  PromotionBudgetPickViewController.swift
//  Pibble-iOS
//
//  Created by Sergey Kazakov on 25/05/2019.
//Copyright © 2019 com.kazai. All rights reserved.
//

import UIKit

//MARK: PromotionBudgetPickView Class
final class PromotionBudgetPickViewController: ViewController {
  @IBAction func nextStepAction(_ sender: Any) {
    presenter.handleNextStepAction()
  }
  
  @IBAction func hideAction(_ sender: Any) {
    presenter.handleHideAction()
  }
  
  @IBOutlet weak var nextButton: UIButton!
  
  
  @IBOutlet weak var budgetInputBackgroundView: UIView!
  
  @IBOutlet weak var headerBudgetValueLabel: UILabel!
  
  @IBOutlet weak var headerReachValueLabel: UILabel!
  
  @IBOutlet weak var budgetLimitationLabel: UILabel!
  
  @IBOutlet weak var budgetCurrencyLabel: UILabel!
  
  @IBOutlet weak var budgetInputTextField: UITextField!
  
  @IBOutlet weak var currentWalletBalanceLabel: UILabel!
  
  
  @IBOutlet weak var durationInputBackgrounView: UIView!
  
  @IBOutlet weak var durationLimitationsLabel: UILabel!
  
  @IBOutlet weak var durationInputTextField: UITextField!
  
  @IBOutlet weak var scrollViewBottomConstraint: NSLayoutConstraint!
  
  
  @IBAction func budgetInputTextFieldEditingChangeAction(_ sender: UITextField) {
    presenter.handleBudgetChangeAction(sender.text ?? "")
  }
  
  @IBAction func durationInoutTextFieldEditingChangedAction(_ sender: UITextField) {
    presenter.handleDurationChangeAction(sender.text ?? "")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupAppearance()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    subscribeKeyboardNotications()
    budgetInputTextField.becomeFirstResponder()
  }
  
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    unsubscribeKeyboardNotications()
  }
}

//MARK: - PromotionBudgetPickView API
extension PromotionBudgetPickViewController: PromotionBudgetPickViewControllerApi {
  func setNextButtonEnabled(_ isEnabled: Bool) {
    nextButton.isEnabled = isEnabled
  }
  
  func setBudget(_ budget: String) {
    budgetInputTextField.text = budget
  }
  
  func setDuration(_ duration: String) {
    durationInputTextField.text = duration
  }
  
  func setBudgetCurrency(_ currency: String) {
    budgetCurrencyLabel.text = currency
  }
  
   func setHeaderViewModel(_ vm: PromotionBudgetPickHeaderViewModelProtocol) {
    headerBudgetValueLabel.text = vm.budgetAndDuration
    headerReachValueLabel.text = vm.reach
  }
  
  func setWalletBalance(_ balance: String) {
    currentWalletBalanceLabel.text = balance
  }
  
  func setBudgetLimitations(_ limitations: String) {
    budgetLimitationLabel.text = limitations
  }
  
  func setDurationLimitations(_ limitations: String) {
    durationLimitationsLabel.text = limitations
  }
}

// MARK: - PromotionBudgetPickView Viper Components API
fileprivate extension PromotionBudgetPickViewController {
  var presenter: PromotionBudgetPickPresenterApi {
    return _presenter as! PromotionBudgetPickPresenterApi
  }
}

extension PromotionBudgetPickViewController {
  fileprivate func setupAppearance() {
    budgetInputBackgroundView.layer.cornerRadius = UIConstants.CornerRadius.inputsBackgroundView
    budgetInputBackgroundView.layer.borderWidth = 1.0
    budgetInputBackgroundView.layer.borderColor = UIConstants.Colors.inputsBackgroundViewBorder.cgColor
    
    durationInputBackgrounView.layer.cornerRadius = UIConstants.CornerRadius.inputsBackgroundView
    durationInputBackgrounView.layer.borderWidth = 1.0
    durationInputBackgrounView.layer.borderColor = UIConstants.Colors.inputsBackgroundViewBorder.cgColor
  }
}

//MARK:- KeyboardNotificationsDelegateProtocol

extension PromotionBudgetPickViewController: KeyboardNotificationsDelegateProtocol {
  func keyBoardWillShowWithBottomInsets(_ bottomInsets: CGFloat, animationOptions: UIView.AnimationOptions, animationDuration: TimeInterval) {
    scrollViewBottomConstraint.constant = bottomInsets
    
    UIView.animate(withDuration: animationDuration, delay: 0.0, options: animationOptions, animations: { [weak self] in
      self?.view.layoutIfNeeded()
    }) { (_) in  }
  }
  
  func keyBoardWillHide(animationOptions: UIView.AnimationOptions, animationDuration: TimeInterval) {
    scrollViewBottomConstraint.constant = 0.0
    
    UIView.animate(withDuration: animationDuration, delay: 0.0, options: animationOptions, animations: { [weak self] in
      self?.view.layoutIfNeeded()
    }) { (_) in  }
  }
}

fileprivate enum UIConstants {
  enum Colors {
    static let inputsBackgroundViewBorder = UIColor.gray168
  }
  
  enum CornerRadius {
    static let inputsBackgroundView: CGFloat = 6.0
  }
}
