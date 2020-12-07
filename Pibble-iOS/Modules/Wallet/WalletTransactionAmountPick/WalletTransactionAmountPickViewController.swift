//
//  WalletRequestAmountPickViewController.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 30.08.2018.
//Copyright © 2018 com.kazai. All rights reserved.
//

import UIKit

//MARK: WalletRequestAmountPickView Class
final class WalletTransactionAmountPickViewController: ViewController {
  @IBOutlet weak var navBarTitle: UILabel!
  @IBOutlet weak var amountInputView: WalletRequestAmountInputView!
  
  @IBOutlet weak var profileHeaderView: WalletProfileHeaderView!
  @IBOutlet weak var profileHeaderViewHeight: NSLayoutConstraint!
  
  @IBAction func hideAction(_ sender: Any) {
    presenter.handleHideAction()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupView()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    amountInputView.setInputAsFirstResponder()
  }
}

//MARK: - WalletRequestAmountPickView API
extension WalletTransactionAmountPickViewController: WalletTransactionAmountPickViewControllerApi {
  func showExchangeDirectionWarningAlert(_ title: String, message: String) {
    let alertController = UIAlertController(title: title, message: message, safelyPreferredStyle: .alert)
    
    alertController.view.tintColor = UIColor.bluePibble
    
    let confirm = UIAlertAction(title: WalletTransactionAmountPick.Strings.confirmExchangeAction.localize(), style: .default) { [weak self] (action) in
      self?.presenter.handleNextStageActionConfirmation()
    }
    
    let cancel = UIAlertAction(title: WalletTransactionAmountPick.Strings.cancelExchangeAction.localize(), style: .cancel) { (action) in
    
    }
    
    alertController.addAction(confirm)
    alertController.addAction(cancel)
    
    present(alertController, animated: true, completion: nil)
    alertController.view.tintColor = UIColor.bluePibble
  }
  
  func setProfile(_ vm: WalletProfileHeaderViewModelProtocol?, animated: Bool) {
    profileHeaderView.setViewModel(vm)
    
    profileHeaderViewHeight.constant = vm == nil ? UIConstants.Constraints.headerViewMinHeight :
      UIConstants.Constraints.headerViewMaxHeight
    guard vm != nil else {
      return
    }
    
    guard animated else {
      return
    }
    
    UIView.animate(withDuration: 0.3) { [weak self] in
      self?.view.layoutIfNeeded()
    }
  }
  
  func setNextStageButtonTitle(_ title: String) {
     
  }
  
  func setNavBarTitle(_ title: String) {
    navBarTitle.text = title
  }
  
  func setNextStageButtonEnabled(_ enabled: Bool) {
    amountInputView.setNextButtonEnabled(enabled)
  }
  
  func setViewModel(_ vm: WalletRequestAmountInputViewModelProtocol?) {
    guard let viewModel = vm else {
      amountInputView.alpha = 0.0
      return
    }
    
    amountInputView.setViewModel(viewModel)
    UIView.animate(withDuration: 0.3) { [weak self] in
      self?.amountInputView.alpha = 1.0
    }
  }
}

// MARK: - WalletRequestAmountPickView Viper Components API
fileprivate extension WalletTransactionAmountPickViewController {
    var presenter: WalletTransactionAmountPickPresenterApi {
        return _presenter as! WalletTransactionAmountPickPresenterApi
    }
}


//MARK:- Helper

extension WalletTransactionAmountPickViewController {
  fileprivate func setupView() {
    amountInputView.nextActionHandler = { [weak self] _ in
      self?.presenter.handleNextStageAction()
    }
    
    amountInputView.inputValueChangedActionHandler = { [weak self] (_, value) in
      self?.presenter.handleAmountChangedAction(value)
    }
    
    amountInputView.swapCurrencyActionHandler = {  [weak self] _ in
      self?.presenter.handleSwapCurrencyAction()
    }
    
    amountInputView.nextCurrencyActionHandler = {  [weak self] _ in
      self?.presenter.handleSwitchToNextCurrency()
    }
  }
}

fileprivate enum UIConstants {
  enum Constraints {
    static let headerViewMaxHeight: CGFloat = 64.0
    static let headerViewMinHeight: CGFloat = 1.0
  }
}


