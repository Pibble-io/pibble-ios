//
//  WalletTransactionCreateViewController.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 10.09.2018.
//Copyright © 2018 com.kazai. All rights reserved.
//


import UIKit

//MARK: WalletInvoiceCreateView Class
final class WalletTransactionCreateViewController: ViewController {
  
  //MARK:- IBOutlets
  @IBOutlet weak var scrollView: UIScrollView!
  @IBOutlet weak var inputContainerView: UIView!
  
  @IBOutlet weak var gradientView: GradientView!
  
  @IBOutlet weak var bottomContainerView: UIView!
  
  @IBOutlet weak var descriptionTextContainerView: UIView!
  @IBOutlet fileprivate weak var mainCurrencyAmountLabel: UILabel!
  @IBOutlet fileprivate weak var mainCurrencyLabel: UILabel!
  
  @IBOutlet fileprivate weak var secondaryCurrencyLabel: UILabel!
  @IBOutlet fileprivate weak var secondaryCurrenctAmountLabel: UILabel!
  
  @IBOutlet weak var recentFriendsSwitchButton: UIButton!
  @IBOutlet weak var friendsSwitchButton: UIButton!
  
  @IBOutlet weak var sergmentControlContainerView: UIView!
  @IBOutlet weak var segmentSelectionView: UIView!
  @IBOutlet weak var contentContainerView: UIView!
  
  @IBOutlet weak var sendButton: UIButton!
  
  @IBOutlet weak var friendsButton: UIButton!
  
  @IBOutlet weak var addressButton: UIButton!
  
  @IBOutlet weak var scanQRCodeButton: UIButton!
  
  @IBOutlet weak var addressInputContainerView: UIView!
  
  @IBOutlet weak var addressTextField: UITextField!
  //MARK:- IBOutlet Constraints
  
  @IBOutlet weak var segmentViewLeftConstraint: NSLayoutConstraint!
  @IBOutlet weak var segmentViewRightConstraint: NSLayoutConstraint!
  
  //MARK:- IBActions
  @IBAction func addressTextFieldEditChangeAction(_ sender: UITextField) {
    presenter.handleAddressChange(sender.text ?? "")
  }
  
  @IBAction func friendsAction(_ sender: Any) {
    presenter.handleSwitchTo(.users)
    setButtonStateFor(WalletTransactionCreate.SelectedUsersSegment.friends)
    presenter.handleSwitchTo(WalletTransactionCreate.SelectedUsersSegment.friends)
  }
  
  @IBAction func addressAction(_ sender: Any) {
    presenter.handleSwitchTo(.address)
  }
  
  @IBAction func scanQRCodeAction(_ sender: Any) {
    presenter.handleSwitchTo(.pickQRCode)
  }
  
  @IBAction func sendAction(_ sender: Any) {
    presenter.handleSendAction()
  }
  
  @IBAction func friendsSwitchAction(_ sender: Any) {
    setButtonStateFor(WalletTransactionCreate.SelectedUsersSegment.friends)
    presenter.handleSwitchTo(WalletTransactionCreate.SelectedUsersSegment.friends)
  }
  
  @IBAction func recentFriendsSwitchAction(_ sender: Any) {
    setButtonStateFor(.recentFriends)
    presenter.handleSwitchTo(.recentFriends)
  }
  
  
  //MARK:- Private properties
  
  fileprivate var contentOffset: CGFloat = 0.0
  fileprivate var canScroll: Bool = true
    
  @IBAction func hideAction(_ sender: Any) {
    presenter.handleHideAction()
  }
  
  //MARK:- Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupView()
    setupAppearance()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    setButtonStateFor(WalletTransactionCreate.SelectedUsersSegment.friends)
    presenter.handleSwitchTo(WalletTransactionCreate.SelectedUsersSegment.friends)
  }
  
  override func viewDidAppear(_ animated: Bool) {
    subscribeKeyboardNotications()
    super.viewDidAppear(animated)
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    unsubscribeKeyboardNotications()
    super.viewWillDisappear(animated)
  }
}

//MARK: - WalletInvoiceCreateView API
extension WalletTransactionCreateViewController: WalletTransactionCreateViewControllerApi {
  func setPostingButtonPresentation(_ enabled: Bool, title: String) {
    sendButton.isEnabled = enabled
    sendButton.setTitleForAllStates(title)
  }
  
  func setWalletAddress(_ address: String) {
    addressTextField.text = address
    [friendsButton, addressButton, scanQRCodeButton].forEach {
      $0?.isSelected = false
    }
    addressButton.isSelected = true
    bottomContainerView.alpha = 0.0
    addressInputContainerView.alpha = 1.0
  }
  
  func setSegmentDeselected() {
    [friendsButton, addressButton, scanQRCodeButton].forEach {
      $0?.isSelected = false
    }
    
    bottomContainerView.alpha = 0.0
    addressInputContainerView.alpha = 0.0
  }
  
  
  func setSelectedSegment(_ segment: WalletTransactionCreate.SelectedSegment) {
    let button: UIButton
    let bottomContainerViewAlpha: CGFloat
    let addressInputContainerViewAlpha: CGFloat
    
    switch segment {
    case .users:
      button = friendsButton
      bottomContainerViewAlpha = 1.0
      addressInputContainerViewAlpha = 0.0
      view.endEditing(true)
    case .address:
      button = addressButton
      bottomContainerViewAlpha = 0.0
      addressInputContainerViewAlpha = 1.0
      addressTextField.becomeFirstResponder()
      presenter.handleAddressChange(addressTextField.text ?? "")
      //scrollView.scrollRectToVisible(addressTextField.frame, animated: true)
    case .pickQRCode:
      button = scanQRCodeButton
      bottomContainerViewAlpha = 0.0
      addressInputContainerViewAlpha = 0.0
      view.endEditing(true)
    }
    
    UIView.animate(withDuration: 0.3) {[weak self] in
      self?.bottomContainerView.alpha = bottomContainerViewAlpha
      self?.addressInputContainerView.alpha = addressInputContainerViewAlpha
    }
    
    guard !button.isSelected else {
      return
    }
    
    [friendsButton, addressButton, scanQRCodeButton].forEach {
      $0?.isSelected = false
    }
    
    let scale: CGFloat = 1.25
    button.isSelected = true
    
    UIView.animate(withDuration: 0.15, animations: {
      button.transform = CGAffineTransform(scaleX: scale, y: scale)
    }) { (_) in
      UIView.animate(withDuration: 0.15, animations: {
        button.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
      }) { (_) in  }
    }
  }
  
  func setViewModel(_ vm: WalletRequestAmountInputViewModelProtocol) {
    mainCurrencyAmountLabel.text = vm.mainCurrencyAmount
    mainCurrencyLabel.text = vm.mainCurrency
    
    secondaryCurrenctAmountLabel.text = vm.secondaryCurrencyAmount
    secondaryCurrencyLabel.text = vm.secondaryCurrency
  }
  
  
  var submoduleContainerView: UIView {
    return contentContainerView
  }
}

// MARK: - WalletInvoiceCreateView Viper Components API
fileprivate extension WalletTransactionCreateViewController {
  var presenter: WalletTransactionCreatePresenterApi {
    return _presenter as! WalletTransactionCreatePresenterApi
  }
}


//MARK:- Helper

extension WalletTransactionCreateViewController {
  fileprivate func setupView() {
    scrollView.delegate = self
  }
  
  fileprivate func setupAppearance() {
    inputContainerView.layer.cornerRadius = UIConstants.CornerRadius.inputContainerView
    inputContainerView.clipsToBounds = true
    
    bottomContainerView.layer.cornerRadius = UIConstants.CornerRadius.bottomContainerView
    bottomContainerView.clipsToBounds = true
    
    descriptionTextContainerView.layer.cornerRadius = UIConstants.CornerRadius.descriptionTextContainerView
    descriptionTextContainerView.clipsToBounds = true
    
    addressInputContainerView.layer.cornerRadius = UIConstants.CornerRadius.addressInputContainerView
    addressInputContainerView.clipsToBounds = true
    
    gradientView.addBackgroundGradientWith(UIConstants.Colors.inputContainerView, direction: .diagonalLeft)
  }
  
  fileprivate func setButtonStateFor(_ segment: WalletTransactionCreate.SelectedUsersSegment) {
    switch segment {
    case .friends:
      friendsSwitchButton.isSelected = true
      recentFriendsSwitchButton.isSelected = false
      
      segmentViewLeftConstraint.priority = .defaultHigh
      segmentViewRightConstraint.priority = .defaultLow
    case .recentFriends:
      friendsSwitchButton.isSelected = false
      recentFriendsSwitchButton.isSelected = true
      
      segmentViewLeftConstraint.priority = .defaultLow
      segmentViewRightConstraint.priority = .defaultHigh
    }
    
    UIView.animate(withDuration: 0.3,
                   delay: 0.0,
                   usingSpringWithDamping: 0.65,
                   initialSpringVelocity: 0.5,
                   options: .curveEaseInOut,
                   animations: { [weak self] in
                    self?.sergmentControlContainerView.layoutIfNeeded()
    }) { (_) in  }
    
  }
}

//MARK:- UIScrollViewDelegate

extension WalletTransactionCreateViewController: UIScrollViewDelegate {
  func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
    guard scrollView == self.scrollView else {
      return
    }
    
    canScroll = true
  }
  
  func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
    guard scrollView == self.scrollView else {
      return
    }
  }
  
  func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
    guard scrollView == self.scrollView else {
      return
    }
    contentOffset = scrollView.contentOffset.y
    canScroll = false
  }
  
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    guard scrollView == self.scrollView else {
      return
    }
    if !canScroll {
      scrollView.contentOffset.y = contentOffset
    }
  }
}

extension WalletTransactionCreateViewController: KeyboardNotificationsDelegateProtocol {
  func keyBoardWillHide(animationOptions: UIView.AnimationOptions, animationDuration: TimeInterval) {
    canScroll = true
    scrollView.contentInset.bottom = 0.0
    UIView.animate(withDuration: animationDuration, delay: 0.0, options: animationOptions, animations: { [weak self] in
      self?.view.layoutIfNeeded()
    }) { (_) in  }
  }
  
  func keyBoardWillShowWithBottomInsets(_ bottomInsets: CGFloat, animationOptions: UIView.AnimationOptions, animationDuration: TimeInterval) {
    canScroll = true
    scrollView.contentInset.bottom = bottomInsets
    
    UIView.animate(withDuration: animationDuration, delay: 0.0, options: animationOptions, animations: { [weak self] in
      self?.view.layoutIfNeeded()
    }) { (_) in  }
  }
}



//MARK:- UIConstants

fileprivate enum UIConstants {
  enum Constraints {
    static let descriptionTextViewMaxHeight: CGFloat = 120.0
    static let descriptionTextViewMinHeight: CGFloat = 36.0
  }
  
  enum Colors {
    static let inputContainerView = UIColor.blueGradient
    static let descriptionTextContainerViewBorder = UIColor.gray112
  }
  
  enum CornerRadius {
    static let inputContainerView: CGFloat = 5.0
    static let bottomContainerView: CGFloat = 5.0
    static let addressInputContainerView: CGFloat = 5.0
    static let descriptionTextContainerView: CGFloat = 8.0
  }
}
