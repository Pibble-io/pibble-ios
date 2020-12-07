//
//  ViperModule.swift
//  Pibble
//
//  Created by Kazakov Sergey on 15.06.2018.
//  Copyright © 2018 com.kazai. All rights reserved.
//

import UIKit

enum ViperViewType {
  case fromStoryboard
  case fromNib
  case fromCode
}

protocol ViperModuleProtocol {
  var viewType: ViperViewType { get }
  var storyboardName: String { get }
}

protocol ConfigurableModule: ViperModuleProtocol {
  var defaultConfigurator: ModuleConfigurator { get }
}

protocol ModuleConfigurator {
  var components: ModuleComponents { get }
}

extension ConfigurableModule {
  
  func build(bundle: Bundle = Bundle.main, deviceType: UIUserInterfaceIdiom? = nil) -> Module? {
    return Module.build(self, bundle: bundle, deviceType: deviceType, components: defaultConfigurator.components)
  }
  
  func build(bundle: Bundle = Bundle.main, deviceType: UIUserInterfaceIdiom? = nil, configurator: ModuleConfigurator) -> Module? {
    return Module.build(self, bundle: bundle, deviceType: deviceType, components: configurator.components)
  }
}
