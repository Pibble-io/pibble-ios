//
//  ChatRoomsContainerRouter.swift
//  Pibble-iOS
//
//  Created by Sergey Kazakov on 11/04/2019.
//Copyright © 2019 com.kazai. All rights reserved.
//

import UIKit

// MARK: - ChatRoomsContainerRouter class
final class ChatRoomsContainerRouter: Router {
  fileprivate var preBuiltModules: [ChatRoomsContainer.SelectedSegment: Module] = [:]
  fileprivate var currentModule: Module?
}

// MARK: - ChatRoomsContainerRouter API
extension ChatRoomsContainerRouter: ChatRoomsContainerRouterApi {
  func routeTo(_ segment: ChatRoomsContainer.SelectedSegment, insideView: UIView) {
    guard let moduleToBePresented = getModuleFor(segment) else {
      return
    }
    
    currentModule?.router.removeFromContainerView()
    currentModule = moduleToBePresented
    moduleToBePresented.router.show(from: presenter._viewController, insideView: insideView)
  }
}

// MARK: - ChatRoomsContainer Viper Components
fileprivate extension ChatRoomsContainerRouter {
  var presenter: ChatRoomsContainerPresenterApi {
    return _presenter as! ChatRoomsContainerPresenterApi
  }
}

fileprivate extension ChatRoomsContainerRouter {
  func getModuleFor(_ segment: ChatRoomsContainer.SelectedSegment) -> Module? {
    if let builtModule = preBuiltModules[segment] {
      return builtModule
    }
    
    let module: Module?
    
    switch segment {
    case .goodsRooms:
      let moduleSetup = AppModules.Messenger.chatRoomGroupsContent
      module = moduleSetup.build()
    case .personalChatRooms:
      let configurator = ChatRoomsModuleConfigurator.contentConfig(AppModules.servicesContainer,
                                                                   .personalChatRooms)
      let moduleSetup = AppModules
        .Messenger
        .chatRooms(.personalChatRooms)
      
      module = moduleSetup.build(configurator: configurator)
    }
    
    guard let builtModule = module else {
      return nil
    }
    
    preBuiltModules[segment] = builtModule
    return builtModule
  }
}
