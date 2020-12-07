//
//  WalletReceiveViewController.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 30.08.2018.
//Copyright © 2018 com.kazai. All rights reserved.
//

import UIKit

//MARK: WalletReceiveView Class
final class WalletReceiveViewController: ViewController {
  @IBOutlet weak var walletInformationContainerView: UIView!
  
  @IBOutlet weak var walletAddressbackgrounView: UIView!
  @IBOutlet weak var qrCodebackgroundContainerView: UIView!
  @IBOutlet weak var qrCodeImageView: UIImageView!
  @IBOutlet weak var walletAddressLabel: UILabel!
  
  @IBOutlet weak var walletAddressTypesContainer: UIView!
  
  @IBOutlet weak var walletAddressTypesStackView: UIStackView!
  
  @IBOutlet weak var sectionsStackView: UIStackView!
  
  
  @IBOutlet weak var walletCurrencyAddressTitleLabel: UILabel!
  @IBAction func copyAddressAction(_ sender: Any) {
    presenter.handleCopyAddressAction()
  }
  
  @IBAction func switchCurrencyAction(_ sender: Any) {
    presenter.handleCurrencySwitchAction()
  }
  
  @IBAction func shareAddressAction(_ sender: Any) {
    presenter.handleShareAction()
  }
  
  @IBAction func requestFromFriendsAction(_ sender: Any) {
    presenter.handleRequestFromFriends()
  }
  
  @IBAction func hideAction(_ sender: Any) {
    presenter.handleHideAction()
  }
  
  //MARK:- Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupAppearance()
  }
  
}

//MARK: - WalletReceiveView API
extension WalletReceiveViewController: WalletReceiveViewControllerApi {
  func setAddressTypesPresentationHidden(_ hidden: Bool, animated: Bool) {
    guard walletAddressTypesContainer.isHidden != hidden else {
      return
    }
    let alpha: CGFloat = hidden ? 0.0 : 1.0
    guard animated else {
      walletAddressTypesContainer.alpha = alpha
      walletAddressTypesContainer.isHidden = hidden
      sectionsStackView.layoutIfNeeded()
      return
    }
    
    UIView.animate(withDuration: 0.3) { [weak self] in
      self?.walletAddressTypesContainer.alpha = alpha
      self?.walletAddressTypesContainer.isHidden = hidden
      self?.sectionsStackView.layoutIfNeeded()
    }
  }
  
  func setAddressTypesViewModel(_ vm: WalletReceiveAddressTypesSectionViewModelProtocol?, animated: Bool) {
    guard let vm = vm else {
      setAddressTypesPresentationHidden(true, animated: animated)
      return
    }
    
    
    walletAddressTypesStackView.arrangedSubviews.forEach {
      walletAddressTypesStackView.removeArrangedSubview($0)
    }
    
    vm.adressTypes.forEach {
      let itemView = WalletReceiveWalledAddressTypeView()
      itemView.setViewModel($0, handler: handleWalletTypeActionsSelectionFor)
      
      walletAddressTypesStackView.addArrangedSubview(itemView)
    }
    
    setAddressTypesPresentationHidden(false, animated: animated)
  }
  
  
  func presentAddressDidCopy() {
    walletAddressbackgrounView.backgroundColor = UIConstants.walletAddressbackgrounViewColorCopied
    
    UIView.animate(withDuration: 0.3) { [weak self] in
      self?.walletAddressbackgrounView.backgroundColor = UIConstants.walletAddressbackgrounViewColorNormal
    }
  }
  
  var addressQRCodeImageSize: CGSize {
    return qrCodeImageView.bounds.size
  }
  
  func setAccountInfo(_ viewModel: WalletReceiveAccountInformationViewModelProtocol?) {
    let alpha: CGFloat = viewModel == nil ? 0.0 : 1.0
    
    UIView.animate(withDuration: 0.3) { [weak self] in
      self?.walletInformationContainerView.alpha = alpha
    }
    
    guard let vm = viewModel else {
      return
    }
    
    qrCodeImageView.image = vm.qrCodeImage
    walletAddressLabel.text = vm.address
    walletCurrencyAddressTitleLabel.attributedText = vm.currencyReceiveAddressTitle
  }
}

// MARK: - WalletReceiveView Viper Components API
fileprivate extension WalletReceiveViewController {
  var presenter: WalletReceivePresenterApi {
    return _presenter as! WalletReceivePresenterApi
  }
}

//MARK:- Helpers

extension WalletReceiveViewController {
  func handleWalletTypeActionsSelectionFor(_ view: WalletReceiveWalledAddressTypeView) {
    guard let index = walletAddressTypesStackView.arrangedSubviews.firstIndex(of: view) else {
      return
    }
    
    presenter.handleAddressTypeSelectionAt(index)
  }
}

extension WalletReceiveViewController {
  fileprivate func setupAppearance() {
    walletInformationContainerView.alpha = 0.0
    qrCodebackgroundContainerView.layer.borderWidth = UIConstants.qrCodeBackgroundBorderWidth
    qrCodebackgroundContainerView.layer.borderColor = UIConstants.qrCodeBackgroundBorderColor.cgColor
  }
}

//MARK:- UIConstants

fileprivate enum UIConstants {
  static let walletAddressbackgrounViewColorCopied = UIColor.bluePibble
  static let walletAddressbackgrounViewColorNormal = UIColor.white
  
  static let qrCodeBackgroundBorderColor = UIColor.gray227
  static let qrCodeBackgroundBorderWidth: CGFloat = 1.0
}
