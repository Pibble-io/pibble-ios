//
//  WalletTransactionCreateRouter.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 10.09.2018.
//Copyright © 2018 com.kazai. All rights reserved.
//

import UIKit

// MARK: - WalletInvoiceCreateRouter class
final class WalletTransactionCreateRouter: Router {
  fileprivate var preBuiltModules: [WalletTransactionCreate.SelectedUsersSegment: Module] = [:]
  fileprivate var currentModule: Module?
  fileprivate let servicesContainer: ServiceContainerProtocol
  
  init(servicesContainer: ServiceContainerProtocol) {
    self.servicesContainer = servicesContainer
  }
}

// MARK: - WalletTransactionCreateRouter API
extension WalletTransactionCreateRouter: WalletTransactionCreateRouterApi {
  func routeToHome() {
    let animated = true
    
    guard let navigationController = _viewController.navigationController else {
        _viewController.dismiss(animated: animated)
        return
    }
    var homeVC: WalletHomeViewController? = nil
    for vc in navigationController.viewControllers {
      homeVC = vc as? WalletHomeViewController
      if homeVC != nil {
        break
      }
    }
    guard let home = homeVC else {
      routeToRoot(animated: animated)
      return
    }
    
    _viewController.navigationController?.popToViewController(home, animated: animated)
  }
  
  func routeToPinCodeUnlock(delegate: WalletPinCodeUnlockDelegateProtocol) {
    AppModules
      .Wallet
      .walletPinCode(.unlock, delegate)
      .build()?
      .router.present(from: _presenter._viewController)
  }
  
  func routeToQRCodeScanner(delegate: ScanQRCodeDelegateProtocol) {
    let configurator = CameraCaptureModuleConfigurator.scanQRCodeConfig(servicesContainer, delegate)
    AppModules
      .CreatePost
      .cameraCapture
      .build(configurator: configurator)?
      .router.present(withPushfrom: presenter._viewController)
    
  }
  
  func routeToCurrencyPicker(transaction: CreateExternalTransactionProtocol) {
    AppModules
      .Wallet
      .walletTransactionCurrencyPick(transaction)
      .build()?
      .router.present(withPushfrom: presenter._viewController)
  }
  
  func routeTo(_ segment: WalletTransactionCreate.SelectedUsersSegment, insideView: UIView, delegate: UserPickDelegateProtocol) {
    guard let moduleToBePresented = getModuleFor(segment, delegate: delegate) else {
      return
    }
    
    currentModule?.router.removeFromContainerView()
    currentModule = moduleToBePresented
    moduleToBePresented.router.show(from: presenter._viewController, insideView: insideView)
  }
}

// MARK: - WalletInvoiceCreate Viper Components
fileprivate extension WalletTransactionCreateRouter {
  var presenter: WalletTransactionCreatePresenterApi {
    return _presenter as! WalletTransactionCreatePresenterApi
  }
}

fileprivate extension WalletTransactionCreateRouter {
  func getModuleFor(_ segment: WalletTransactionCreate.SelectedUsersSegment, delegate: UserPickDelegateProtocol) -> Module? {
    if let builtModule = preBuiltModules[segment] {
      return builtModule
    }
    
    let moduleSetup: ConfigurableModule
    
    switch segment {
    case .friends:
      moduleSetup = AppModules.Wallet.walletInvoiceCreateFriendsContent(.friends, delegate)
    case .recentFriends:
      moduleSetup = AppModules.Wallet.walletInvoiceCreateFriendsContent(.recentFriends, delegate)
    }
    
    guard let module = moduleSetup.build() else {
      return nil
    }
    
    preBuiltModules[segment] = module
    return module
  }
}
