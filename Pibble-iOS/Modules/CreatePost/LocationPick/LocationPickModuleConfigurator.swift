//
//  LocationPickModuleConfigurator.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 23.07.2018.
//Copyright © 2018 com.kazai. All rights reserved.
//

import UIKit

enum LocationPickModuleConfigurator: ModuleConfigurator {
  case defaultConfig(ServiceContainerProtocol, LocationPickDelegateProtocol)
  
  var components: ModuleComponents {
    switch self {
    case .defaultConfig(let container, let locationDelegate):
      return (V: LocationPickViewController.self,
              I: LocationPickInteractor(postingService: container.postingService,
                                        locationSearchService: container.locationSearchService),
              P: LocationPickPresenter(delegate: locationDelegate),
              R: LocationPickRouter())
    }
  }
}
