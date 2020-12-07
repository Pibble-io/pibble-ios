//
//  CameraCaptureModuleConfigurator.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 05.07.2018.
//Copyright © 2018 com.kazai. All rights reserved.
//

import UIKit

enum CameraCaptureModuleConfigurator: ModuleConfigurator {
  case defaultConfig(ServiceContainerProtocol)
  case photoConfig(ServiceContainerProtocol, MediaCaptureDelegateProtocol)
  case videoConfig(ServiceContainerProtocol, MediaCaptureDelegateProtocol)
  case scanQRCodeConfig(ServiceContainerProtocol, ScanQRCodeDelegateProtocol)
  
  var components: ModuleComponents {
    switch self {
    case .defaultConfig(let container):
      return (V: CameraCaptureViewController.self,
              I: CameraCaptureInteractor(cameraCaptureService: container.cameraCaptureService),
              P: CameraCapturePresenter(mediaCaptureDelegate: nil, scanQRCodeDelegate: nil),
              R: CameraCaptureRouter())
    case .photoConfig(let container, let delegate):
      return (V: CameraPhotoCaptureViewController.self,
              I: CameraCaptureInteractor(cameraCaptureService: container.cameraCaptureService),
              P: CameraCapturePresenter(mediaCaptureDelegate: delegate, scanQRCodeDelegate: nil),
              R: CameraCaptureRouter())
    case .videoConfig(let container, let delegate):
      return (V: CameraVideoCaptureViewController.self,
              I: CameraCaptureInteractor(cameraCaptureService: container.cameraCaptureService),
              P: CameraCapturePresenter(mediaCaptureDelegate: delegate, scanQRCodeDelegate: nil),
              R: CameraCaptureRouter())
    case .scanQRCodeConfig(let container, let delegate):
      return (V: CameraQRCodeCaptureViewController.self,
              I: CameraCaptureInteractor(cameraCaptureService: container.cameraQRScanCaptureService),
              P: CameraCapturePresenter(mediaCaptureDelegate: nil, scanQRCodeDelegate: delegate),
              R: CameraCaptureRouter())
      
    }
  }
}
