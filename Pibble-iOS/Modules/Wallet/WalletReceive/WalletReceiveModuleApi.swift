//
//  WalletReceiveModuleApi.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 30.08.2018.
//Copyright © 2018 com.kazai. All rights reserved.
//
import UIKit

//MARK: - WalletReceiveRouter API
protocol WalletReceiveRouterApi: WalletPinCodeSecuredRouterProtocol {
  func routeToShareControlWith(_ text: String)
  func routeToRequestAmount(_ accountProfile: AccountProfileProtocol)
}

//MARK: - WalletReceiveView API
protocol WalletReceiveViewControllerApi: ViewControllerProtocol {
  func setAccountInfo(_ viewModel: WalletReceiveAccountInformationViewModelProtocol?)
  var addressQRCodeImageSize: CGSize { get }
  func presentAddressDidCopy()
  func setAddressTypesPresentationHidden(_ hidden: Bool, animated: Bool)
  func setAddressTypesViewModel(_ vm: WalletReceiveAddressTypesSectionViewModelProtocol?, animated: Bool)
}

//MARK: - WalletReceivePresenter API
protocol WalletReceivePresenterApi: PresenterProtocol {
  func handleHideAction()
  func handleCopyAddressAction()
  func handleShareAction()
  func handleRequestFromFriends()
  func handleCurrencySwitchAction()
  
  func handleAddressTypeSelectionAt(_ index: Int) 
  
  func presentUserProfile(_ profile: UserProtocol?)
}


//MARK: - WalletReceiveInteractor API
protocol WalletReceiveInteractorApi: InteractorProtocol {
  func fetchInitialData()
  var profile: AccountProfileProtocol? { get }
  var availableCurrencies: [BalanceCurrency] { get }
}

protocol WalletReceiveAccountInformationViewModelProtocol {
  var address: String { get }
  var qrCodeImage: UIImage { get }
  var currencyReceiveAddressTitle: NSAttributedString { get }
}

protocol WalletReceiveAddressTypesSectionViewModelProtocol {
  var adressTypes: [WalletReceiveAddressTypeViewModelProtocol] { get }
}

protocol WalletReceiveAddressTypeViewModelProtocol {
  var isSelected: Bool { get }
  var title: String { get }
}
