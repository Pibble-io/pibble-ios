//
//  GoodsPostDetailModuleConfigurator.swift
//  Pibble-iOS
//
//  Created by Sergey Kazakov on 30/07/2019.
//Copyright © 2019 com.kazai. All rights reserved.
//

import UIKit

enum GoodsPostDetailModuleConfigurator: ModuleConfigurator {
  case defaultConfig
  
  var components: ModuleComponents {
    switch self {
    case .defaultConfig:
      return (V: GoodsPostDetailViewController.self,
              I: GoodsPostDetailInteractor(),
              P: GoodsPostDetailPresenter(),
              R: GoodsPostDetailRouter())
    }
  }
}
