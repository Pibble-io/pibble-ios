//
//  LeaderboardContainerRouter.swift
//  Pibble-iOS
//
//  Created by Sergey Kazakov on 19/07/2019.
//Copyright © 2019 com.kazai. All rights reserved.
//

import UIKit

// MARK: - LeaderboardContainerRouter class
final class LeaderboardContainerRouter: Router {
  fileprivate var preBuiltModules: [LeaderboardContainer.SelectedSegment: Module] = [:]
  fileprivate var currentModule: Module?
}

// MARK: - LeaderboardContainerRouter API
extension LeaderboardContainerRouter: LeaderboardContainerRouterApi {
  func routeTo(_ segment: LeaderboardContainer.SelectedSegment, insideView: UIView) {
    guard let moduleToBePresented = getModuleFor(segment) else {
      return
    }
    
    currentModule?.router.removeFromContainerView()
    currentModule = moduleToBePresented
    moduleToBePresented.router.show(from: presenter._viewController, insideView: insideView)
  }
  
  func routeToWebsiteAt(_ url: URL) {
    let configurator = ExternalLinkModuleConfigurator.modalConfig(url, url.absoluteString)
    let module = AppModules
      .Settings
      .externalLink(url, url.absoluteString)
      .build(configurator: configurator)
    
    module?.router.present(withDissolveFrom: presenter._viewController)
  }
}

// MARK: - LeaderboardContainer Viper Components
fileprivate extension LeaderboardContainerRouter {
  var presenter: LeaderboardContainerPresenterApi {
    return _presenter as! LeaderboardContainerPresenterApi
  }
}

fileprivate extension LeaderboardContainerRouter {
  func getModuleFor(_ segment: LeaderboardContainer.SelectedSegment) -> Module? {
    if let builtModule = preBuiltModules[segment] {
      return builtModule
    }
    
    let module: Module?
    switch segment {
    case .day:
      let moduleSetup = AppModules.Posts.leaderboardContent(.days(1))
      module = moduleSetup.build()
    case .week:
      let moduleSetup = AppModules.Posts.leaderboardContent(.days(7))
      module = moduleSetup.build()
    case .allHistory:
      let moduleSetup = AppModules.Posts.leaderboardContent(.allHistory)
      module = moduleSetup.build()
    }
    
    guard let builtModule = module else {
      return nil
    }
    
    preBuiltModules[segment] = builtModule
    return builtModule
  }
}
