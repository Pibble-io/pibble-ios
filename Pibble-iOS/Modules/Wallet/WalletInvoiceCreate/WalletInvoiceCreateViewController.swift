//
//  WalletInvoiceCreateViewController.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 31.08.2018.
//Copyright © 2018 com.kazai. All rights reserved.
//

import UIKit

//MARK: WalletInvoiceCreateView Class
final class WalletInvoiceCreateViewController: ViewController {
  
  //MARK:- IBOutlets
  @IBOutlet weak var scrollView: UIScrollView!
  @IBOutlet weak var inputContainerView: UIView!
  @IBOutlet weak var bottomContainerView: UIView!
  
  @IBOutlet weak var inputContainerGradientView: GradientView!
  @IBOutlet weak var descriptionTextContainerView: UIView!
  @IBOutlet fileprivate weak var mainCurrencyAmountLabel: UILabel!
  @IBOutlet fileprivate weak var mainCurrencyLabel: UILabel!
  
  @IBOutlet fileprivate weak var secondaryCurrencyLabel: UILabel!
  @IBOutlet fileprivate weak var secondaryCurrenctAmountLabel: UILabel!
  
  @IBOutlet weak var descriptionTextView: UITextView!
  
  @IBOutlet weak var recentFriendsSwitchButton: UIButton!
  @IBOutlet weak var friendsSwitchButton: UIButton!
  
  @IBOutlet weak var sergmentControlContainerView: UIView!
  @IBOutlet weak var segmentSelectionView: UIView!
  @IBOutlet weak var contentContainerView: UIView!
 
  @IBOutlet weak var sendButton: UIButton!
  
  //MARK:- IBOutlet Constraints
  
  @IBOutlet weak var segmentViewLeftConstraint: NSLayoutConstraint!
  @IBOutlet weak var segmentViewRightConstraint: NSLayoutConstraint!
  
  @IBOutlet weak var descriptionTextViewHeightConstraint: NSLayoutConstraint!
  
  //MARK:- IBActions
  @IBAction func sendAction(_ sender: Any) {
    presenter.handleSendAction()
  }
  
  @IBAction func friendsSwitchAction(_ sender: Any) {
    setButtonStateFor(.friends)
    presenter.handleSwitchTo(.friends)
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
    setButtonStateFor(.friends)
    presenter.handleSwitchTo(.friends)
  }
}

//MARK: - WalletInvoiceCreateView API
extension WalletInvoiceCreateViewController: WalletInvoiceCreateViewControllerApi {
  func setPostingButtonInteraction(_ enabled: Bool) {
    sendButton.isUserInteractionEnabled = enabled
  }
  
  func setViewModel(_ vm: WalletRequestAmountInputViewModelProtocol) {
    mainCurrencyAmountLabel.text = vm.mainCurrencyAmount
    mainCurrencyLabel.text = vm.mainCurrency
    
    secondaryCurrenctAmountLabel.text = vm.secondaryCurrencyAmount
    secondaryCurrencyLabel.text = vm.secondaryCurrency
  }
  
  func setPostingButtonPresentation(_ enabled: Bool) {
    sendButton.isEnabled = enabled
  }
  
  var submoduleContainerView: UIView {
    return contentContainerView
  }
}

// MARK: - WalletInvoiceCreateView Viper Components API
fileprivate extension WalletInvoiceCreateViewController {
  var presenter: WalletInvoiceCreatePresenterApi {
    return _presenter as! WalletInvoiceCreatePresenterApi
  }
}


//MARK:- Helper

extension WalletInvoiceCreateViewController {
  fileprivate func setupView() {
    descriptionTextView.delegate = self
    scrollView.delegate = self
  }
  
  fileprivate func setupAppearance() {
    inputContainerView.layer.cornerRadius = UIConstants.CornerRadius.inputContainerView
    inputContainerView.clipsToBounds = true
    
    bottomContainerView.layer.cornerRadius = UIConstants.CornerRadius.bottomContainerView
    bottomContainerView.clipsToBounds = true
    
    descriptionTextContainerView.layer.cornerRadius = UIConstants.CornerRadius.descriptionTextContainerView
    descriptionTextContainerView.clipsToBounds = true
    
    descriptionTextView.tintColor = UIConstants.Colors.descriptionTextContainerViewBorder
    descriptionTextContainerView.layer.borderWidth = 1.0
    descriptionTextContainerView.layer.borderColor = UIConstants.Colors.descriptionTextContainerViewBorder.cgColor
    
    inputContainerGradientView.addBackgroundGradientWith(UIConstants.Colors.inputContainerView, direction: .diagonalLeft)
  }
  
  fileprivate func setButtonStateFor(_ segment: WalletInvoiceCreate.SelectedSegment) {
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

//MARK:- 

extension WalletInvoiceCreateViewController: UIScrollViewDelegate {
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


//MARK:- UITextViewDelegate

extension WalletInvoiceCreateViewController: UITextViewDelegate {
  func textViewDidChange(_ textView: UITextView) {
    updateEditViewForTextContent()
    presenter.handleDescriptionChanged(textView.text)
  }
  
  fileprivate func updateEditViewForTextContent() {
    let fittingSize = descriptionTextView.sizeThatFits(CGSize(width: descriptionTextView.frame.size.width, height: 9999))
    
    let textViewMinHeight = UIConstants.Constraints.descriptionTextViewMinHeight
    let viewMaxHeight = UIConstants.Constraints.descriptionTextViewMaxHeight
    let trueViewHeight = max(textViewMinHeight, CGFloat(fittingSize.height))
    let viewContentHeight = min(viewMaxHeight, trueViewHeight)
    
    descriptionTextViewHeightConstraint.constant = viewContentHeight
    
    UIView.animate(withDuration: 0.2, delay: 0.0, options: .beginFromCurrentState, animations: { [weak self] in
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
    
    static let descriptionTextContainerView: CGFloat = 8.0
  }
}
