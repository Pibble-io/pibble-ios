//
//  TabBarModuleModuleConfigurator.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 15.06.2018.
//Copyright © 2018 com.kazai. All rights reserved.
//

import UIKit

enum TabBarModuleConfigurator: ModuleConfigurator {
  case defaultConfig(ServiceContainerProtocol, [TabBar.MainItems: ConfigurableModule])
  
  var components: ModuleComponents {
    switch self {
    case .defaultConfig(let diContainer, let tabBarModules):
      return (V: TabBarViewController.self,
              I: TabBarInteractor(pushNotificationsService: diContainer.pushNotificationService),
              P: TabBarPresenter(),
              R: TabBarRouter(tabBarModules: tabBarModules))
    }
  }
}



