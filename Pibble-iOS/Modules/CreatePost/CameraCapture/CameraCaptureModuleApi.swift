//
//  CameraCaptureModuleApi.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 05.07.2018.
//Copyright © 2018 com.kazai. All rights reserved.
//

import UIKit
import AVFoundation

//MARK: - CameraCaptureRouter API

protocol CameraCaptureRouterApi: RouterProtocol {
  func routeToPostingScreenFrom(_ viewController: ViewController, mediaAssets: MediaType)
}

//MARK: - CameraCaptureView API

protocol CameraCaptureViewControllerApi: ViewControllerProtocol {
  func removeCaptureLayer()
  func setCaptureLayer(_ layer: CALayer)
  
  func setRecordingProgressBar(percentage: Double)
  func setMinVideoLengthIndicator(percentage: Double)
  func setVideoTimeLimit(_ value: String)
  func setCurrentVideoLength(_ value: String)
  func setButtonsRecordingState(_ recording: Bool, animated: Bool)
  func setProgressBarRecordingState(_ recording: Bool, animated: Bool)
  func setCurrentTimerValue(_ value: String, isActive: Bool)
  
  func presentVideoTimelimitReachedAlert()
}

//MARK: - CameraCapturePresenter API
protocol CameraCapturePresenterApi: PresenterProtocol {
  func handleHideAction()
  func handleCaptureVideoStartAction()
  func handleCaptureVideoEndAction()
  func handleCapturePhotoAction()
  func handleSwitchCameraAction()
  func handleFinishAction()
  func handleAutoshotAction()
  
  func presentCaptureLayer(_ layer: CALayer)
  func presentVideoCaptureFinished()
  func presentPhotoCaptureFinished(_ images: [UIImage])
  func presentPhotoCapturedCount(_ count: Int, isAutoshotScheduled: Bool)
  func presentExportedVideo(_ asset: URL)
  
  func presentScannedQRCode(_ code: String, in bounds: CGRect)
}

//MARK: - CameraCaptureInteractor API
protocol CameraCaptureInteractorApi: InteractorProtocol {
  var recordingProgressPerCent: Double { get }
  var currentVideoLegth: TimeInterval { get }
  var videoMaxDuration: TimeInterval { get }
  var videoMinDuration: TimeInterval { get }
  
  func prepare()
  func stopSession()
  
  func exportRecordedVideo()
  
  func captureVideoStart()
  func captureVideoEnd()
  func capturePhoto()
  func switchCamera()
  
  func schedulePhotoCaptureAfter(_ timeInterval: TimeInterval, numberOfCaptures: Int, with interval: TimeInterval)
}

protocol ScanQRCodeDelegateProtocol: class {
  func didCaptureQRCode(_ code: String)
}

protocol MediaCaptureDelegateProtocol: class {
  func didCaptureVideo(_ videoFileURL: URL)
  func didCaptureImages(_ images: [UIImage])
}

protocol VideoCaptureDelegateProtocol: class {
  func didCapturedVideo(_ code: String)
}
