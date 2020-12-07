//
//  WalletTransactionCurrencyPickPresenter.swift
//  Pibble-iOS
//
//  Created by Sergey Kazakov on 08/07/2019.
//Copyright © 2019 com.kazai. All rights reserved.
//

import UIKit

// MARK: - WalletTransactionCurrencyPickPresenter Class
final class WalletTransactionCurrencyPickPresenter: Presenter {
  override func viewDidLoad() {
    super.viewDidLoad()
    interactor.initialFetchData()
    presentWarning()
    presentTitle()
  }
}

// MARK: - WalletTransactionCurrencyPickPresenter API
extension WalletTransactionCurrencyPickPresenter: WalletTransactionCurrencyPickPresenterApi {
  func handleHideAction() {
    router.dismiss()
  }
  
  func presentTransactionSentSuccefully(_ success: Bool) {
    guard success else {
      viewController.setSendButtonEnabled(true)
      return
    }
    
    router.routeToHome()
  }
  
  func presentCurrencies(_ currencies: [BalanceCurrency], selectedCurrency: BalanceCurrency?) {
    let viewModels = currencies
      .map { WalletTransactionCurrencyPick.ItemViewModel(isSelected: $0 == selectedCurrency,
                                                   title: $0.rawSymbolPresentation) }
    
    viewController.setViewItemsModels(viewModels, animated: isPresented)
    viewController.setSendButtonEnabled(selectedCurrency != nil)
  }
  
  func handleCurrencySelectionAt(_ index: Int) {
    interactor.selectCurrencyAt(index)
  }
  
  func handleSendAction() {
    viewController.setSendButtonEnabled(false)
    guard interactor.hasPinCode else {
      router.routeToPinCodeUnlock(delegate: self)
      return
    }
    
    interactor.createTransaction()
  }
  
  func presentTitle() {
    let title = WalletTransactionCurrencyPick.Strings.title.localize(value: interactor.initialCurrency.symbol)
    viewController.setCurrencyTitle(title)
  }
  
  func presentWarning() {
    let title = WalletTransactionCurrencyPick.Strings.Warning.warningTitle.localize()
    let subtitle = WalletTransactionCurrencyPick.Strings.Warning.warningSubtitle.localize()
    
    let titleString = NSAttributedString(string: title,
                       attributes: [
                        NSAttributedString.Key.font: UIConstants.Fonts.warningTitle,
                        NSAttributedString.Key.foregroundColor: UIConstants.Colors.warningTitle])
    
    let spaceString = NSAttributedString(string: " ",
                                         attributes: [
                                          NSAttributedString.Key.font: UIConstants.Fonts.warningTitle,
                                          NSAttributedString.Key.foregroundColor: UIConstants.Colors.warningTitle])
    
    let subtitleString = NSAttributedString(string: subtitle,
                                         attributes: [
                                          NSAttributedString.Key.font: UIConstants.Fonts.warningTitle,
                                          NSAttributedString.Key.foregroundColor: UIConstants.Colors.warningSubtitle])
    
    let warningString = NSMutableAttributedString()
    warningString.append(titleString)
    warningString.append(spaceString)
    warningString.append(subtitleString)
    viewController.setWarningTitle(warningString)
  }
}

// MARK: - WalletTransactionCurrencyPick Viper Components
fileprivate extension WalletTransactionCurrencyPickPresenter {
  var viewController: WalletTransactionCurrencyPickViewControllerApi {
    return _viewController as! WalletTransactionCurrencyPickViewControllerApi
  }
  var interactor: WalletTransactionCurrencyPickInteractorApi {
    return _interactor as! WalletTransactionCurrencyPickInteractorApi
  }
  var router: WalletTransactionCurrencyPickRouterApi {
    return _router as! WalletTransactionCurrencyPickRouterApi
  }
}

extension WalletTransactionCurrencyPickPresenter: WalletPinCodeUnlockDelegateProtocol {
  func walletDidUnlockWith(_ pinCode: String) {
    interactor.createTransaction()
  }
  
  func walletDidFailToUnlock() {
    viewController.setSendButtonEnabled(true)
  }
}


fileprivate enum UIConstants {
  enum Fonts {
    static let warningTitle = UIFont.AvenirNextMedium(size: 13.0)
  }
  
  enum Colors {
    static let warningTitle = UIColor.red
    static let warningSubtitle = UIColor.gray70
  }
}
