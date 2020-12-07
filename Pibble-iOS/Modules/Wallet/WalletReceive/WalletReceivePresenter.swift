//
//  WalletReceivePresenter.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 30.08.2018.
//Copyright © 2018 com.kazai. All rights reserved.
//

import UIKit

// MARK: - WalletReceivePresenter Class
final class WalletReceivePresenter: WalletPinCodeSecuredPresenter {
  fileprivate var currencyIndex: Int = 0
  fileprivate var availableCurrencies: [BalanceCurrency] {
    return interactor.availableCurrencies
  }
    
  fileprivate var selectedWallet: WalletProtocol?
  
  override func viewDidLoad() {
    super.viewDidLoad()
   
  }
  
  override func viewDidAppear() {
    super.viewDidAppear()
    interactor.fetchInitialData()
  }
}

// MARK: - WalletReceivePresenter API
extension WalletReceivePresenter: WalletReceivePresenterApi {
  func handleAddressTypeSelectionAt(_ index: Int) {
    guard let userAccount = interactor.profile else {
      viewController.setAccountInfo(nil)
      return
    }
    
    let selectedCurrency = availableCurrencies[currencyIndex]
    let walletsForSelectedCurrency = userAccount.walletsForCurrency(selectedCurrency)
    
    guard index < walletsForSelectedCurrency.count && index >= 0 else {
      return
    }
    
    
    selectedWallet = walletsForSelectedCurrency[index]
    
    guard let wallet = selectedWallet else {
      return
    }
    
    let walletsToPresent = selectedCurrency.hasUnderlyingCurrencies ? walletsForSelectedCurrency : nil
    presentWallets(wallet, walletsTypesForSelectedCurrency: walletsToPresent)
  }
  
  func handleCurrencySwitchAction() {
    currencyIndex += 1
    
    guard let profile = interactor.profile,
            availableCurrencies.count > 0 else {
      currencyIndex = 0
      return
    }
    
    if currencyIndex >= availableCurrencies.count {
      currencyIndex = 0
    }
    
    presentUserProfile(profile)
  }
  
  fileprivate func presentWallets(_ selectedWallet: WalletProtocol, walletsTypesForSelectedCurrency: [WalletProtocol]?) {
    let imageSize = viewController.addressQRCodeImageSize
    let currentWalletAddress = selectedWallet.walletAddress
    let currentWalletAddressCurrency = selectedWallet.walletCurrency.symbolPresentation
    
    guard let qrCodeImage = UIImage.createQRCodeImageFrom(currentWalletAddress, size: imageSize) else {
      viewController.setAccountInfo(nil)
      return
    }
    
    let receiveAddressBegin =
      NSAttributedString(string: WalletReceivePresenter.Strings.Title.recieveAddressBegin.localize(),
                         attributes: [
                          NSAttributedString.Key.font: UIFont.AvenirNextRegular(size: 20.0),
                          NSAttributedString.Key.foregroundColor: UIConstants.Colors.recieveAddressTitle
        ])
    
    let receiveAddressEnd =
      NSAttributedString(string: WalletReceivePresenter.Strings.Title.recieveAddressEnd.localize(),
                         attributes: [
                          NSAttributedString.Key.font: UIFont.AvenirNextRegular(size: 20.0),
                          NSAttributedString.Key.foregroundColor: UIConstants.Colors.recieveAddressTitle
        ])
    
    let receiveAddressCurrency =
      NSAttributedString(string: currentWalletAddressCurrency,
                         attributes: [
                          NSAttributedString.Key.font: UIFont.AvenirNextDemiBold(size: 20.0),
                          NSAttributedString.Key.foregroundColor: UIConstants.Colors.recieveAddressCurrency
        ])
    
    let receiveAddressAttrString = NSMutableAttributedString()
    receiveAddressAttrString.append(receiveAddressBegin)
    receiveAddressAttrString.append(receiveAddressCurrency)
    receiveAddressAttrString.append(receiveAddressEnd)
    
    let vm = WalletReceive.AccountInformationViewModel(address: currentWalletAddress,
                                                       qrCodeImage: qrCodeImage,
                                                       currencyReceiveAddressTitle: receiveAddressAttrString)
    
    viewController.setAccountInfo(vm)
    
    guard let walletsTypesForSelectedCurrency = walletsTypesForSelectedCurrency else  {
      viewController.setAddressTypesViewModel(nil, animated: isPresented)
      return
    }
    
    let addressTypeSectionVM = WalletReceive.AddressTypesSectionViewModel(wallets: walletsTypesForSelectedCurrency, selectedWallets: selectedWallet)
    
    viewController.setAddressTypesViewModel(addressTypeSectionVM, animated: isPresented)
    
  }
  
  func presentUserProfile(_ profile: UserProtocol?) {
    guard let userAccount = profile,
      availableCurrencies.count > currencyIndex else {
      viewController.setAccountInfo(nil)
      return
    }
    
    let selectedCurrency = availableCurrencies[currencyIndex]
    let walletsForSelectedCurrency = userAccount.walletsForCurrency(selectedCurrency)
    selectedWallet = walletsForSelectedCurrency.first
    
    guard let wallet = selectedWallet else {
      viewController.setAccountInfo(nil)
      return
    }
    
    let walletsToPresent = selectedCurrency.hasUnderlyingCurrencies ? walletsForSelectedCurrency : nil
    presentWallets(wallet, walletsTypesForSelectedCurrency: walletsToPresent)
  }
  
  func handleHideAction() {
    router.dismiss()
  }
  
  func handleCopyAddressAction() {
    guard let _ = interactor.profile else {
      return
    }
    
    viewController.presentAddressDidCopy()
    guard let wallet = selectedWallet else {
      return
    }
    
    UIPasteboard.general.string = wallet.walletAddress
  }
  
  func handleShareAction() {
    guard let _ = interactor.profile else {
      return
    }
    
    guard let wallet = selectedWallet else {
      return
    }
    
    let currentWalletAddress = wallet.walletAddress
    let currentWalletCurrency = wallet.walletCurrency.rawSymbolPresentation
    let shareText = WalletReceivePresenter.Strings.shareTextForCurrency.localize(values: currentWalletCurrency, currentWalletAddress)
    
    router.routeToShareControlWith(shareText)
  }
  
  func handleRequestFromFriends() {
    guard let profile = interactor.profile else {
      return
    }
    
    router.routeToRequestAmount(profile)
  }
}

// MARK: - WalletReceive Viper Components
fileprivate extension WalletReceivePresenter {
    var viewController: WalletReceiveViewControllerApi {
        return _viewController as! WalletReceiveViewControllerApi
    }
    var interactor: WalletReceiveInteractorApi {
        return _interactor as! WalletReceiveInteractorApi
    }
    var router: WalletReceiveRouterApi {
        return _router as! WalletReceiveRouterApi
    }
}


//MARK:- Helper
fileprivate extension UserProtocol {
//  fileprivate func walletsAvailableForRecieve() -> [WalletProtocol] {
//    return userWallets.sorted { $0.walletCurrency.rawValue > $1.walletCurrency.rawValue }
//  }
  
  fileprivate func walletsForCurrency(_ currency: BalanceCurrency) -> [WalletProtocol] {
    guard currency.hasUnderlyingCurrencies else {
      return userWallets.filter { $0.walletCurrency == currency }
    }
    
    let underlyingCurrencies = Set(currency.underlyingCurrencies)
    
    return userWallets
      .filter { underlyingCurrencies.contains($0.walletCurrency) }
      .sorted { $0.walletCurrency.rawValue > $1.walletCurrency.rawValue }
  }
}

fileprivate enum UIConstants {
//  static func myWalletAddressShareText(currency: String) -> String {
//    return "My \(currency) wallet address:"
//  }
//
//  static let recieveAddressBegin = "Your receiving "
//  static let recieveAddressEnd = " address"
  
  enum Colors {
    static let recieveAddressTitle = UIColor.gray70
    static let recieveAddressCurrency = UIColor.bluePibble
  }
}


extension WalletReceivePresenter {
  enum Strings: String, LocalizedStringKeyProtocol  {
    case shareTextForCurrency = "My % wallet address: %"
    
    enum Title: String, LocalizedStringKeyProtocol {
      case recieveAddressBegin = "Your receiving "
      case recieveAddressEnd = " address"
    }
  }
}
