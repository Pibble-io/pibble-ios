//
//  WalletActivityContentRouter.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 25.08.2018.
//Copyright © 2018 com.kazai. All rights reserved.
//

import Foundation

// MARK: - WalletActivityContentRouter class
final class WalletActivityContentRouter: Router {
}

// MARK: - WalletActivityContentRouter API
extension WalletActivityContentRouter: WalletActivityContentRouterApi {
  func routeToUserProfileFor(_ user: UserProtocol) {
    let targetUser: UserProfileContent.TargetUser = (user.isCurrent ?? false) ? .current : .other(user)
    
    AppModules
      .UserProfile
      .userProfileContainer(targetUser)
      .build()?
      .router.present(withPushfrom: presenter._viewController)
  }
  
  func routeToPinCodeUnlock(delegate: WalletPinCodeUnlockDelegateProtocol) {
    AppModules
      .Wallet
      .walletPinCode(.unlock, delegate)
      .build()?
      .router.present(from: _presenter._viewController)
  }
}

// MARK: - WalletActivityContent Viper Components
fileprivate extension WalletActivityContentRouter {
    var presenter: WalletActivityContentPresenterApi {
        return _presenter as! WalletActivityContentPresenterApi
    }
}
