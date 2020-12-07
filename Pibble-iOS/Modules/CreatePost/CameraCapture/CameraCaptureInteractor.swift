//
//  CameraCaptureInteractor.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 05.07.2018.
//Copyright © 2018 com.kazai. All rights reserved.
//

import UIKit

// MARK: - CameraCaptureInteractor Class
final class CameraCaptureInteractor: Interactor {
  fileprivate let cameraCaptureService: CameraCaptureServiceProtocol
  
  fileprivate var photoCaptureDelayInterval: TimeInterval = 3.0
  fileprivate var numberOfCaptures = 0
  fileprivate var photoCapturesInbetweenDelay: TimeInterval = 1.0
  fileprivate var capturedPhotos: [UIImage] = []
  fileprivate var countDownIteration = 0
  fileprivate var countDownIterationTimeInterval: TimeInterval = 1.0
  fileprivate var photoCaptureDelayTimer: Timer? {
    didSet {
      oldValue?.invalidate()
    }
  }
  
  fileprivate var photoCaptureCountdownRefreshTimer: Timer? {
    didSet {
      oldValue?.invalidate()
    }
  }
  
  var videoMaxDuration: TimeInterval {
    return cameraCaptureService.maxDuration
  }
  
  var videoMinDuration: TimeInterval {
    return cameraCaptureService.minDuration
  }
  
  init(cameraCaptureService: CameraCaptureServiceProtocol) {
    self.cameraCaptureService = cameraCaptureService
    super.init()
    self.cameraCaptureService.scanQRCodeDelegate = self
  }
}

// MARK: - CameraCaptureInteractor API
extension CameraCaptureInteractor: CameraCaptureInteractorApi {
  func schedulePhotoCaptureAfter(_ timeInterval: TimeInterval, numberOfCaptures: Int, with interval: TimeInterval) {
    capturedPhotos = []
    self.numberOfCaptures = numberOfCaptures
    photoCapturesInbetweenDelay = interval
    photoCaptureDelayInterval = timeInterval
    countDownIteration = Int(timeInterval / countDownIterationTimeInterval)
    
    scheduleCountDownUpdate()
    performScheduledPhotoCapture()
  }
  
  fileprivate func scheduleCountDownUpdate() {
    presenter.presentPhotoCapturedCount(countDownIteration, isAutoshotScheduled: true)
    guard countDownIteration > 0 else {
      return
    }
    
    photoCaptureCountdownRefreshTimer = Timer.scheduledTimer(withTimeInterval: countDownIterationTimeInterval, repeats: false, block: { [weak self] (_) in
      
      guard let strongSelf = self else {
        return
      }
      
      strongSelf.countDownIteration -= 1
      strongSelf.scheduleCountDownUpdate()
    })
  }
  
  fileprivate func performScheduledPhotoCapture() {
    guard capturedPhotos.count < numberOfCaptures else {
      presenter.presentPhotoCapturedCount(capturedPhotos.count, isAutoshotScheduled: false)
      presenter.presentPhotoCaptureFinished(capturedPhotos)
      return
    }
    
    let interval = capturedPhotos.count == 0 ? photoCaptureDelayInterval : photoCapturesInbetweenDelay
    photoCaptureDelayTimer = Timer.scheduledTimer(withTimeInterval: interval, repeats: false, block: { [weak self] (_) in
      
      guard let strongSelf = self else {
        return
      }
      
      strongSelf.cameraCaptureService.captureImage(completion: { [weak self] (img, err) in
          guard let strongSelf = self else {
            return
          }
        
          if let error = err {
            strongSelf.presenter.handleError(error)
            return
          }
        
          if let image = img {
            strongSelf.capturedPhotos.append(image)
          }
        
//        strongSelf.presenter.presentPhotoCapturedCount(strongSelf.capturedPhotos.count,
//                                                       isAutoshotScheduled: true)
          strongSelf.performScheduledPhotoCapture()
      })
    })
  }
  
  func exportRecordedVideo() {
    cameraCaptureService.exportRecordedVideo { [weak self] in
      switch $0 {
      case .success(let assetExportSession):
        self?.presenter.presentExportedVideo(assetExportSession)
      case .failure(let error):
        self?.presenter.handleError(error)
      }
  
    }
  }
  
  var currentVideoLegth: TimeInterval {
    return cameraCaptureService.currentVideoRecordingSessionDuration
  }
  
  var recordingProgressPerCent: Double {
    return min(100.0, 100.0 * cameraCaptureService.currentVideoRecordingSessionDuration / cameraCaptureService.maxDuration)
  }
  
  func stopSession() {
    cameraCaptureService.stopCaptureSession()
  }
  
  func prepare() {
    cameraCaptureService.prepare { [weak self] in
      guard let strongSelf = self else {
        return
      }
      if let error = $0 {
        strongSelf.presenter.handleError(error)
        return
      }
      
      strongSelf.cameraCaptureService.startCaptureSession { [weak self] err in
        guard let strongSelf = self else {
          return
        }
        
        if let error = err {
          strongSelf.presenter.handleError(error)
          return
        }
       
        do {
          let previewLayer = try strongSelf.cameraCaptureService.getPreviewLayer()
          if let layer = previewLayer {
            strongSelf.presenter.presentCaptureLayer(layer)
          }
        } catch {
          strongSelf.presenter.handleError(error)
        }
      }
    }
  }
  
  func captureVideoStart() {
    cameraCaptureService.startRecording() { [weak self] in
      guard let strongSelf = self else {
        return
      }
      
      if let error = $0 {
        strongSelf.presenter.handleError(error)
        return
      }
      //strongSelf.presenter.presentVideoCaptureFinished()
    }
  }
  
  func captureVideoEnd() {
    presenter.presentVideoCaptureFinished()
    cameraCaptureService.stopRecording()
  }
  
  func capturePhoto() {
    cameraCaptureService.captureImage { [weak self] ( image, error) in
      if let error = error {
        self?.presenter.handleError(error)
        return
      }
      
      guard let image = image else {
        return
      }
      
      AppLogger.debug("capturePhoto saved")
      
      self?.presenter.presentPhotoCaptureFinished([image])
    }
  }
  
  func switchCamera() {
    try? cameraCaptureService.switchCameras()
  }
  
}

// MARK: - Interactor Viper Components Api
private extension CameraCaptureInteractor {
    var presenter: CameraCapturePresenterApi {
        return _presenter as! CameraCapturePresenterApi
    }
}

extension CameraCaptureInteractor: CameraCaptureScanQRCodeDelegateProtocol {
  func didCaptureQRCode(_ code: String, in bounds: CGRect) {
    presenter.presentScannedQRCode(code, in: bounds)
  }
}
