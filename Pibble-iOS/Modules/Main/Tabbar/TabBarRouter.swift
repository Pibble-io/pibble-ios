//
//  TabBarModuleRouter.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 15.06.2018.
//Copyright © 2018 com.kazai. All rights reserved.
//

import UIKit

// MARK: - TabBarModuleRouter class
 
final class TabBarRouter: Router {
  fileprivate var preBuiltModules: [TabBar.MainItems: Module] = [:]
  fileprivate let tabBarModules: [TabBar.MainItems: ConfigurableModule]
  
  fileprivate var currentModule: Module?
  fileprivate var currentItem: TabBar.MainItems?
  
  init(tabBarModules: [TabBar.MainItems: ConfigurableModule]) {
    self.tabBarModules = tabBarModules
  }
}

// MARK: - TabBarModuleRouter API
extension TabBarRouter: TabBarRouterApi {
  func routeTo(_ menuItem: TabBar.MenuItems) {
    switch menuItem {
    case .camera:
      let module = AppModules
        .CreatePost
        .mediaSource(PostDraft(postingType: .media))
        .build()
      
      //let module = AppModules.Posting.mediaPick.build()
      module?.router.present(from: presenter._viewController, embedInNavController: true)
    case .commerce:
      let module = AppModules
        .CreatePost
        .mediaSource(PostDraft(postingType: .digitalGood))
        .build()
      
      module?.router.present(from: presenter._viewController, embedInNavController: true)
    case .funding:
      let module = AppModules
        .CreatePost
        .mediaSource(PostDraft(postingType: .crowdfunding))
        .build()
      
      module?.router.present(from: presenter._viewController, embedInNavController: true)
    case .charity:
      let module = AppModules
        .CreatePost
        .mediaSource(PostDraft(postingType: .charity))
        .build()
      
      module?.router.present(from: presenter._viewController, embedInNavController: true)
    case .album:
      break
    case .goods:
      let module = AppModules
        .CreatePost
        .mediaSource(PostDraft(postingType: .goods))
        .build()
      
      module?.router.present(from: presenter._viewController, embedInNavController: true)
    case .notifications:
      let module =  AppModules
        .Notifications
        .notificationsFeed
        .build()
      module?.router.present(withPushfrom: presenter._viewController)
    case .gift:
      let module = AppModules
        .Gifts
        .giftsFeed(.giftHome)
        .build()
      
      module?.router.present(withPushfrom: presenter._viewController)
    case .wallet:
      let module = AppModules
        .Wallet
        .walletHome
        .build()
      
      module?.router.present(withPushfrom: presenter._viewController)
    case .settings:
      let module = AppModules
        .Settings
        .settingsHome
        .build()
      
      module?.router.present(withPushfrom: presenter._viewController)
    }
  }
  
  
  func routeTo(_ tabBarItem: TabBar.MainItems, insideView: UIView) {
    guard let moduleToBePresented = getModuleFor(tabBarItem) else {
     return
    }
    
    if TabBar.MainItems.fourth == tabBarItem {
      moduleToBePresented.router.present(from: presenter._viewController)
      return
    }
    
    if let current = currentItem, current == tabBarItem {
      currentModule?.presenter.presentInitialState()
      currentModule?.presenter._viewController
        .navigationController?
        .popToRootViewController(animated: true)
      return
    }
    
    currentModule?.router.removeFromContainerView()
    currentModule = moduleToBePresented
    currentItem = tabBarItem
    moduleToBePresented.router.show(from: presenter._viewController, insideView: insideView, embedInNavController: true)
  }
}

// MARK: - TabBarModule Viper Components
private extension TabBarRouter {
    var presenter: TabBarPresenterApi {
        return _presenter as! TabBarPresenterApi
    }
}

fileprivate extension TabBarRouter {
  func getModuleFor(_ tabBarItem: TabBar.MainItems) -> Module? {
    if let builtModule = preBuiltModules[tabBarItem] {
      return builtModule
    }
    
    if let moduleSetup = tabBarModules[tabBarItem],
        let module = moduleSetup.build() {
      
        if tabBarItem != .fourth {
          preBuiltModules[tabBarItem] = module
        }
        return module
    }
    
    return nil
  }
}
