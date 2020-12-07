//
//  WalletTransactionCurrencyPickViewController.swift
//  Pibble-iOS
//
//  Created by Sergey Kazakov on 08/07/2019.
//Copyright © 2019 com.kazai. All rights reserved.
//

import UIKit

//MARK: WalletTransactionCurrencyPickView Class
final class WalletTransactionCurrencyPickViewController: ViewController {
  @IBOutlet weak var sendButton: UIButton!
  
  @IBOutlet weak var currencyTypesTitleLabel: UILabel!
  
  @IBOutlet weak var stackView: UIStackView!
  
  @IBOutlet weak var warningLabel: UILabel!
  
  @IBOutlet weak var inputsContainerView: UIView!
  @IBOutlet weak var gradientView: GradientView!
  
  @IBAction func hideAction(_ sender: Any) {
    presenter.handleHideAction()
  }
  
  @IBAction func sendAction(_ sender: Any) {
    presenter.handleSendAction()
  }

  
  //MARK:- Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupView()
    setupAppearance()
  }
}

//MARK: - WalletTransactionCurrencyPickView API
extension WalletTransactionCurrencyPickViewController: WalletTransactionCurrencyPickViewControllerApi {
  func setCurrencyTitle(_ text: String) {
    currencyTypesTitleLabel.text = text
  }
  
  func setWarningTitle(_ attributedText: NSAttributedString) {
    warningLabel.attributedText = attributedText
  }
  
  func setViewItemsModels(_ vms: [WalletTransactionCurrencyPickItemViewModelProtocol], animated: Bool) {
    
    stackView.arrangedSubviews.forEach {
      $0.removeFromSuperview()
    }
    
    vms.forEach {
      let itemView = WalletTransactionCurrencyPickItemView()
      itemView.setViewModel($0, handler: handleSelectionActionFor)
      
      stackView.addArrangedSubview(itemView)
    }
  }
  
  func setSendButtonEnabled(_ enabled: Bool) {
    sendButton.isEnabled = enabled
  }
  
}

// MARK: - WalletTransactionCurrencyPickView Viper Components API
fileprivate extension WalletTransactionCurrencyPickViewController {
  var presenter: WalletTransactionCurrencyPickPresenterApi {
    return _presenter as! WalletTransactionCurrencyPickPresenterApi
  }
}

extension WalletTransactionCurrencyPickViewController {
  func handleSelectionActionFor(_ view: WalletTransactionCurrencyPickItemView) {
    guard let index = stackView.arrangedSubviews.firstIndex(of: view) else {
      return
    }
    
    presenter.handleCurrencySelectionAt(index)
  }
}

//MARK:- Helpers

extension WalletTransactionCurrencyPickViewController {
  fileprivate func setupView() {
    gradientView.addBackgroundGradientWith(UIConstants.Colors.backgroundGradient, direction: .diagonalLeft)
  }
  
  fileprivate func setupAppearance() {
    inputsContainerView.clipsToBounds = true
    inputsContainerView.layer.cornerRadius = UIConstants.contentViewCornerRadius
  }
}

fileprivate enum UIConstants {
  static let inputMaxCharLength: Int = 10
  static let nextButtonBorderWidth: CGFloat = 1.0
  
  static let contentViewCornerRadius: CGFloat = 5.0
  
  enum Colors {
    static let nextButtonBorder = UIColor.white
    static let backgroundGradient = UIColor.blueGradient
  }
}
