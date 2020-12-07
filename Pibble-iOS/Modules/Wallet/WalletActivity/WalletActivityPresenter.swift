//
//  WalletActivityPresenter.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 24.08.2018.
//Copyright © 2018 com.kazai. All rights reserved.
//

import Foundation

// MARK: - WalletActivityPresenter Class
final class WalletActivityPresenter: WalletPinCodeSecuredPresenter {
  
  override func viewWillAppear() {
    super.viewWillAppear()
  }
}

// MARK: - WalletActivityPresenter API
extension WalletActivityPresenter: WalletActivityPresenterApi {
  func handleSwitchTo(_ segment: WalletActivity.SelectedSegment) {
    router.routeTo(segment, insideView: viewController.submoduleContainerView)
  }
  
  func handleHideAction() {
    router.dismiss()
  }
}

// MARK: - WalletActivity Viper Components
fileprivate extension WalletActivityPresenter {
    var viewController: WalletActivityViewControllerApi {
        return _viewController as! WalletActivityViewControllerApi
    }
    var interactor: WalletActivityInteractorApi {
        return _interactor as! WalletActivityInteractorApi
    }
    var router: WalletActivityRouterApi {
        return _router as! WalletActivityRouterApi
    }
}

//MARK:- Helper

extension WalletActivityPresenter {
 
}
