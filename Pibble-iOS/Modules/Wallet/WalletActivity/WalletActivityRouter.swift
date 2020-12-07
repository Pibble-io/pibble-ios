//
//  WalletActivityRouter.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 24.08.2018.
//Copyright © 2018 com.kazai. All rights reserved.
//

import UIKit

// MARK: - WalletActivityRouter class
final class WalletActivityRouter: Router {
  fileprivate var preBuiltModules: [WalletActivity.SelectedSegment: Module] = [:]
  fileprivate let contentModules: [WalletActivity.SelectedSegment: ConfigurableModule]
  
  fileprivate var currentModule: Module?
  
  init(contentModules: [WalletActivity.SelectedSegment: ConfigurableModule]) {
    self.contentModules = contentModules
  }
}

// MARK: - WalletActivityRouter API
extension WalletActivityRouter: WalletActivityRouterApi {
  func routeTo(_ segment: WalletActivity.SelectedSegment, insideView: UIView) {
    guard let moduleToBePresented = getModuleFor(segment) else {
      return
    }
    
    currentModule?.router.removeFromContainerView()
    currentModule = moduleToBePresented
    moduleToBePresented.router.show(from: presenter._viewController, insideView: insideView)
  }
}

// MARK: - WalletActivity Viper Components
fileprivate extension WalletActivityRouter {
    var presenter: WalletActivityPresenterApi {
        return _presenter as! WalletActivityPresenterApi
    }
}


fileprivate extension WalletActivityRouter {
  func getModuleFor(_ segment: WalletActivity.SelectedSegment) -> Module? {
    if let builtModule = preBuiltModules[segment] {
      return builtModule
    }
    
    if let moduleSetup = contentModules[segment],
      let module = moduleSetup.build() {
      preBuiltModules[segment] = module
      return module
    }
    
    return nil
  }
}
