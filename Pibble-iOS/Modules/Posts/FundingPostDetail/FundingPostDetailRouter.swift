//
//  FundingPostDetailRouter.swift
//  Pibble-iOS
//
//  Created by Sergey Kazakov on 06/02/2019.
//Copyright © 2019 com.kazai. All rights reserved.
//

import Foundation

// MARK: - FundingPostDetailRouter class
final class FundingPostDetailRouter: Router {
}

// MARK: - FundingPostDetailRouter API
extension FundingPostDetailRouter: FundingPostDetailRouterApi {
//  func routeToChatRoom(_ room: ChatRoomProtocol) {
//    AppModules
//      .Messenger
//      .chat(.existingRoom(room))
//      .build()?
//      .router.present(withPushfrom: presenter._viewController)
//  }
//
//  func routeToChatRoomForUser(_ user: UserProtocol) {
//    AppModules
//      .Messenger
//      .chat(.roomForUser([user]))
//      .build()?
//      .router.present(withPushfrom: presenter._viewController)
//  }
  
  func routeToDonate(delegate: DonateDelegateProtocol, donationAmountMinStep: Double?) {
    let amountPickType: Donate.AmountPickType =
      donationAmountMinStep?
        .toInt()
        .map { .fixedStepAmount($0) } ?? .anyAmount
    
    AppModules
      .Posts
      .donate(delegate, [.pibble, .redBrush, .greenBrush], amountPickType)
      .build()?
      .router.present(withDissolveFrom: presenter._viewController)
  }
  
  func routeToExternalLinkAt(_ url: URL) {
    let configurator = ExternalLinkModuleConfigurator.modalConfig(url, url.absoluteString)
    let module = AppModules
      .Settings
      .externalLink(url, url.absoluteString)
      .build(configurator: configurator)
    
    module?.router.present(withDissolveFrom: presenter._viewController)
  }
  
  func routeToChatRoomForPost(_ post: PostingProtocol) {
    AppModules
      .Messenger
      .chat(.roomForPost(post))
      .build()?
      .router.present(withPushfrom: presenter._viewController)
  }
  
  func routeToEULAForPost(_ post: PostingProtocol) {
    
  }
}

// MARK: - FundingPostDetail Viper Components
fileprivate extension FundingPostDetailRouter {
  var presenter: FundingPostDetailPresenterApi {
    return _presenter as! FundingPostDetailPresenterApi
  }
}
