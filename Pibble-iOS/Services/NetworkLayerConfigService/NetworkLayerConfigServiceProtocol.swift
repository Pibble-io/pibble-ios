//
//  NetworkLayerConfigServiceProtocol.swift
//  Pibble
//
//  Created by Kazakov Sergey on 02.10.2018.
//  Copyright © 2018 com.kazai. All rights reserved.
//

import Foundation
import Moya

protocol NetworkLayerConfigServiceProtocol {
  var plugins: [PluginType] { get }
  func configureProvider<Target: TargetType>() -> MoyaProvider<Target>
}
 
