//
//  CameraCapturePresenter.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 05.07.2018.
//Copyright © 2018 com.kazai. All rights reserved.
//

import UIKit
import AVFoundation

// MARK: - CameraCapturePresenter Class
final class CameraCapturePresenter: Presenter {
  fileprivate weak var scanQRCodeDelegate: ScanQRCodeDelegateProtocol?
  fileprivate weak var mediaCaptureDelegate: MediaCaptureDelegateProtocol?
  
  fileprivate var appearedAt = Date()
  fileprivate let scanQRCaptureMinInterval: TimeInterval = 0.5
  fileprivate var didCaptureQRCode = false
  
  fileprivate let autoshotDelay: TimeInterval = 3.0
  fileprivate let autoshotInbetweenDelay: TimeInterval = 1.0
  fileprivate let autoshotImageCount = 3
  
  
  fileprivate var recordingTimer: Timer? {
    didSet {
      oldValue?.invalidate()
    }
  }
  
  //fileprivate var recordingProgress: Float = 0.0
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  override func viewWillDisappear() {
    super.viewWillDisappear()
    viewController.removeCaptureLayer()
  }
  
  override func viewWillAppear() {
    super.viewWillAppear()
    interactor.prepare()
  viewController.setVideoTimeLimit(interactor.videoMaxDuration.formattedMinutesSecondsTimeString)
    let progress = interactor.recordingProgressPerCent
    viewController.setRecordingProgressBar(percentage: progress)
    
    viewController.setButtonsRecordingState(false, animated: false)
    viewController.setProgressBarRecordingState(false, animated: false)
  }
  
  override func viewDidAppear() {
    super.viewDidAppear()
    let minDurationProgress = minDurationPercentage()
    viewController.setMinVideoLengthIndicator(percentage: minDurationProgress)
    appearedAt = Date()
  }
  
  override func viewDidDisappear() {
    super.viewDidDisappear()
  }
  
  init(mediaCaptureDelegate: MediaCaptureDelegateProtocol?, scanQRCodeDelegate: ScanQRCodeDelegateProtocol?) {
    self.scanQRCodeDelegate = scanQRCodeDelegate
    self.mediaCaptureDelegate = mediaCaptureDelegate
  }
}

// MARK: - CameraCapturePresenter API
extension CameraCapturePresenter: CameraCapturePresenterApi {
  func presentPhotoCapturedCount(_ count: Int, isAutoshotScheduled: Bool) {
    viewController.setCurrentTimerValue(String(count), isActive: isAutoshotScheduled)
  }
 
  
  func handleAutoshotAction() {
    interactor.schedulePhotoCaptureAfter(autoshotDelay, numberOfCaptures: autoshotImageCount, with: autoshotInbetweenDelay)
  }
  
  func presentScannedQRCode(_ code: String, in bounds: CGRect) {
    guard abs(appearedAt.timeIntervalSinceNow) > scanQRCaptureMinInterval else {
      return
    }
    
    guard !didCaptureQRCode else {
      return
    }
    
    didCaptureQRCode = true
    scanQRCodeDelegate?.didCaptureQRCode(code)
    router.dismiss()
  }
  
  func presentExportedVideo(_ assetExportSession: URL) {
    mediaCaptureDelegate?.didCaptureVideo(assetExportSession)
  }
  
  func presentVideoCaptureFinished() {
    recordingTimer = nil
    let progress = interactor.recordingProgressPerCent
    viewController.setRecordingProgressBar(percentage: progress)
    viewController.setButtonsRecordingState(false, animated: true)
  }
  
  func presentPhotoCaptureFinished(_ images: [UIImage]) {
    mediaCaptureDelegate?.didCaptureImages(images)
  }
  
  func presentCaptureLayer(_ layer: CALayer) {
    viewController.setCaptureLayer(layer)
  }
  
  func handleFinishAction() {
    AppLogger.debug("handleFinishAction")
    interactor.exportRecordedVideo()
  }
  
  func handleHideAction() {
    router.dismiss()
  }
  
  func handleCaptureVideoStartAction() {
    recordingTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] (_) in
      guard let strongSelf = self else {
        return
      }
      let progress = strongSelf.interactor.recordingProgressPerCent
      let length = strongSelf.interactor.currentVideoLegth.formattedMinutesSecondsTimeString
      strongSelf.viewController.setRecordingProgressBar(percentage: progress)
      strongSelf.viewController.setCurrentVideoLength(length)
      
      guard strongSelf.interactor.currentVideoLegth < strongSelf.interactor.videoMaxDuration else {
        strongSelf.recordingTimer = nil
        strongSelf.interactor.captureVideoEnd()
        strongSelf.viewController.presentVideoTimelimitReachedAlert()
        return
      }
    }
    
    viewController.setButtonsRecordingState(true, animated: true)
    viewController.setProgressBarRecordingState(true, animated: true)
    interactor.captureVideoStart()
  }
  
  func handleCaptureVideoEndAction() {
    recordingTimer = nil
    interactor.captureVideoEnd()
  }
  
  func handleCapturePhotoAction() {
    interactor.capturePhoto()
  }
  
  func handleSwitchCameraAction() {
    interactor.switchCamera()
  }
}

// MARK: - CameraCapture Viper Components
fileprivate extension CameraCapturePresenter {
    var viewController: CameraCaptureViewControllerApi {
        return _viewController as! CameraCaptureViewControllerApi
    }
    var interactor: CameraCaptureInteractorApi {
        return _interactor as! CameraCaptureInteractorApi
    }
    var router: CameraCaptureRouterApi {
        return _router as! CameraCaptureRouterApi
    }
}

extension CameraCapturePresenter {
  fileprivate func minDurationPercentage() -> Double {
    return 100.0 * interactor.videoMinDuration / interactor.videoMaxDuration
  }
}
