//
//  ChatRouter.swift
//  Pibble-iOS
//
//  Created by Sergey Kazakov on 11/02/2019.
//Copyright © 2019 com.kazai. All rights reserved.
//

import UIKit


// MARK: - ChatRouter class
final class ChatRouter: Router {
}

// MARK: - ChatRouter API
extension ChatRouter: ChatRouterApi {
  func routeToPinCodeUnlock(delegate: WalletPinCodeUnlockDelegateProtocol) {
    AppModules
      .Wallet
      .walletPinCode(.unlock, delegate)
      .build()?
      .router.present(from: _presenter._viewController)
  }
  
  func routeToShareControlWith(_ urls: [URL], completion: @escaping ((UIActivity.ActivityType?, Bool) -> Void)) {
    let vc = UIActivityViewController(activityItems: urls, applicationActivities: [])
    vc.completionWithItemsHandler = { (activityType, success, items, error) in
      completion(activityType, success)
    }
    presenter._viewController.present(vc, animated: true, completion: nil)
  }
  
  func routeToWallet() {
    AppModules
      .Wallet
      .walletHome
      .build()?
      .router.present(withPushfrom: presenter._viewController)
  }
  
  func routeToUserProfileFor(_ user: UserProtocol) {
    let targetUser: UserProfileContent.TargetUser = (user.isCurrent ?? false) ? .current : .other(user)
    
    AppModules
      .UserProfile
      .userProfileContainer(targetUser)
      .build()?
      .router.present(withPushfrom: presenter._viewController)
  }
  
  func routeToMediaDetails(_ post: PostingProtocol, media: MediaProtocol) {
    AppModules
      .Posts
      .mediaDetail(post, media)
      .build()?
      .router.present(withDissolveFrom: presenter._viewController)
  }
  
}

// MARK: - Chat Viper Components
fileprivate extension ChatRouter {
  var presenter: ChatPresenterApi {
    return _presenter as! ChatPresenterApi
  }
}
