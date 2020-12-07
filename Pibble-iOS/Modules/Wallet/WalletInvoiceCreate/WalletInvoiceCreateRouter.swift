//
//  WalletInvoiceCreateRouter.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 31.08.2018.
//Copyright © 2018 com.kazai. All rights reserved.
//

import UIKit

// MARK: - WalletInvoiceCreateRouter class
final class WalletInvoiceCreateRouter: Router {
  fileprivate var preBuiltModules: [WalletInvoiceCreate.SelectedSegment: Module] = [:]
  fileprivate var currentModule: Module?
}

// MARK: - WalletInvoiceCreateRouter API
extension WalletInvoiceCreateRouter: WalletInvoiceCreateRouterApi {
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
  
  func routeTo(_ segment: WalletInvoiceCreate.SelectedSegment, insideView: UIView, delegate: UserPickDelegateProtocol) {
    guard let moduleToBePresented = getModuleFor(segment, delegate: delegate) else {
      return
    }
    
    currentModule?.router.removeFromContainerView()
    currentModule = moduleToBePresented
    moduleToBePresented.router.show(from: presenter._viewController, insideView: insideView)
  }
}

// MARK: - WalletInvoiceCreate Viper Components
fileprivate extension WalletInvoiceCreateRouter {
  var presenter: WalletInvoiceCreatePresenterApi {
    return _presenter as! WalletInvoiceCreatePresenterApi
  }
}



fileprivate extension WalletInvoiceCreateRouter {
  func getModuleFor(_ segment: WalletInvoiceCreate.SelectedSegment, delegate: UserPickDelegateProtocol) -> Module? {
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

