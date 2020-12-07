//
//  ModuleBuilderError.swift
//  Pibble
//
//  Created by Kazakov Sergey on 15.06.2018.
//  Copyright © 2018 com.kazai. All rights reserved.
//

import Foundation

enum ModuleBuilderError : Error, PibbleErrorProtocol {
  case methodNotImplemented
  case cannotBuildViewFor(storyboardName: String, viewControllerId: String)
  case navigationControllerNotFound
  
  var description: String {
    var message = ""
    switch self {
    case .methodNotImplemented: message = "Method not implemented"
    case .cannotBuildViewFor(let storyboardName, let viewControllerId): message = "Cannot find VC in Storyboard: \(storyboardName) with id: \(viewControllerId)"
    case .navigationControllerNotFound: message = "attempt to push from absent navigation controller"
      
    }
    
    return "[MODULE BUILDER ERROR]: \(message)"
  }
}

extension ModuleBuilderError: LocalizedError {
  var errorDescription: String? {
    return description
  }
}

