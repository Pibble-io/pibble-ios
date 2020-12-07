//
//  CameraCaptureRouter.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 05.07.2018.
//Copyright © 2018 com.kazai. All rights reserved.
//

import UIKit
import AVFoundation

// MARK: - CameraCaptureRouter class
final class CameraCaptureRouter: Router {
  
}

// MARK: - CameraCaptureRouter API
extension CameraCaptureRouter: CameraCaptureRouterApi {
  func routeToPostingScreenFrom(_ viewController: ViewController, mediaAssets: MediaType) {
    
  }
  
  
}

// MARK: - CameraCapture Viper Components
fileprivate extension CameraCaptureRouter {
    var presenter: CameraCapturePresenterApi {
        return _presenter as! CameraCapturePresenterApi
    }
}
