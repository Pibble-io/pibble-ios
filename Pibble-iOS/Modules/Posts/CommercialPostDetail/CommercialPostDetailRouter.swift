//
//  CommercialPostDetailRouter.swift
//  Pibble-iOS
//
//  Created by Sergey Kazakov on 06/02/2019.
//Copyright © 2019 com.kazai. All rights reserved.
//

import Foundation

// MARK: - CommercialPostDetailRouter class
final class CommercialPostDetailRouter: Router {
}

// MARK: - CommercialPostDetailRouter API
extension CommercialPostDetailRouter: CommercialPostDetailRouterApi {
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

// MARK: - CommercialPostDetail Viper Components
fileprivate extension CommercialPostDetailRouter {
  var presenter: CommercialPostDetailPresenterApi {
    return _presenter as! CommercialPostDetailPresenterApi
  }
}
