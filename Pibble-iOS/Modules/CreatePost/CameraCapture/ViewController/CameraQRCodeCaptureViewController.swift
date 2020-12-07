//
//  CameraQRCodeCaptureViewController.swift
//  Pibble
//
//  Created by Kazakov Sergey on 11.09.2018.
//  Copyright © 2018 com.kazai. All rights reserved.
//

import UIKit
import AVFoundation

final class CameraQRCodeCaptureViewController: ViewController {
  //MARK:- IBOutlets
  
  @IBOutlet weak var captureView: UIView!
  
  @IBOutlet weak var scanBackgroundView: UIView!
  //MARK:- IBActions
  
  @IBAction func hideAction(_ sender: Any) {
    presenter.handleHideAction()
  }
  
  //MARK:- Private properties
  
  fileprivate var captureLayer: CALayer?
  
  //MARK:- Lifecycle
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    subscribeDeviceOrientationNotications()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupAppearance()
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    unsubscribeDeviceOrientationNotications()
  }
  
  //MARK:- Overrides
  
  override var prefersStatusBarHidden: Bool {
    return false
  }
}

// MARK: - CameraQRCodeCaptureViewController Viper Components API

fileprivate extension CameraQRCodeCaptureViewController {
  var presenter: CameraCapturePresenterApi {
    return _presenter as! CameraCapturePresenterApi
  }
}

extension CameraQRCodeCaptureViewController: CameraCaptureViewControllerApi {
  func presentVideoTimelimitReachedAlert() {
     
  }
  
  func setCurrentTimerValue(_ value: String, isActive: Bool) {
    
  }
  
  func setMinVideoLengthIndicator(percentage: Double) { }
  
  func setProgressBarRecordingState(_ recording: Bool, animated: Bool) { }
  
  func setCurrentVideoLength(_ value: String) { }
  func setButtonsRecordingState(_ recording: Bool, animated: Bool) {  }
  
  func removeCaptureLayer() {
    captureLayer?.removeFromSuperlayer()
  }
  
  func setVideoTimeLimit(_ value: String) { }
  
  func setRecordingProgressBar(percentage: Double) {   }
  
  func setCaptureLayer(_ layer: CALayer) {
    layer.frame = captureView.frame
    captureView.layer.insertSublayer(layer, at: 0)
    captureLayer = layer
  }
}

// MARK: - CameraCaptureView Viper Components API
fileprivate extension CameraCaptureViewController {
  var presenter: CameraCapturePresenterApi {
    return _presenter as! CameraCapturePresenterApi
  }
}


//MARK: - Helpers

fileprivate extension CameraQRCodeCaptureViewController {
  func setupAppearance() {
    scanBackgroundView.layer.cornerRadius = UIConstants.CornerRadius.scanBackgroundView
    scanBackgroundView.clipsToBounds = true
  }
}


//MARK:- DeviceOrientationNotificationsDelegateProtocol

extension CameraQRCodeCaptureViewController: DeviceOrientationNotificationsDelegateProtocol {
  func deviceOrientationDidChangeTo(_ orientation: UIDeviceOrientation) {
     
  }
}
//MARK:- UIConstants

fileprivate enum UIConstants {
  enum BorderWidths {
    static let circleProgressBar: CGFloat = 3.0
  }
  
  enum CornerRadius {
    static let scanBackgroundView: CGFloat = 3.0
  }
  
  enum Colors {
    static let videoButtonBorder = UIColor.lightGray
    static let photoButtonBorder = UIColor.white
    
    static let progressBarBackgroundCircle = UIColor.lightGray
    static let progressBarCircle = UIColor.red
  }
  
}
