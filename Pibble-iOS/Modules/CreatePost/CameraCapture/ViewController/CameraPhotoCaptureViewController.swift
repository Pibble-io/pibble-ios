//
//  CameraPhotoCaptureViewController.swift
//  Pibble
//
//  Created by Kazakov Sergey on 09.07.2018.
//  Copyright © 2018 com.kazai. All rights reserved.
//

import UIKit
import AVFoundation

final class CameraPhotoCaptureViewController: ViewController {
  //MARK:- IBOutlets
  
  @IBOutlet weak var buttonsBackgroundView: UIView!
  
  @IBOutlet weak var captureView: UIView!
  @IBOutlet weak var capturePhotoButton: UIButton!
//  @IBOutlet weak var capturePhotoButtonBackgroundView: UIView!
  @IBOutlet weak var burstPhotoSeriesButton: UIButton!
  
  @IBOutlet weak var swapCameraButton: UIButton!
  
   //MARK:- IBActions
  
  @IBAction func hideAction(_ sender: Any) {
    presenter.handleHideAction()
  }
  @IBAction func burstPhotoSeriesAction(_ sender: Any) {
    presenter.handleAutoshotAction()
  }
  
  @IBAction func capturePhotoAction(_ sender: Any) {
    presenter.handleCapturePhotoAction()
  }
  
  @IBAction func switchCameraAction(_ sender: Any) {
    presenter.handleSwitchCameraAction()
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
    return true
  }
  
  override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
    return .all
  }
}

// MARK: - CameraPhotoCaptureViewController Viper Components API

fileprivate extension CameraPhotoCaptureViewController {
  var presenter: CameraCapturePresenterApi {
    return _presenter as! CameraCapturePresenterApi
  }
}

extension CameraPhotoCaptureViewController: CameraCaptureViewControllerApi {
  func presentVideoTimelimitReachedAlert() {
    
  }
  
  func setCurrentTimerValue(_ value: String) {
    
  }
  
  func setCurrentTimerValue(_ value: String, isActive: Bool) {
    burstPhotoSeriesButton.setTitleForAllStates(value)
    let image = isActive ? #imageLiteral(resourceName: "CameraCapture-SeriesShotSelected") : #imageLiteral(resourceName: "CameraCapture-SeriesShot")
    burstPhotoSeriesButton.setBackgroundImage(image, for: .normal)
  }
  
  func setMinVideoLengthIndicator(percentage: Double) { }
  
  
  func setProgressBarRecordingState(_ recording: Bool, animated: Bool) { }
  
  func setCurrentVideoLength(_ value: String) { }
  func setButtonsRecordingState(_ recording: Bool, animated: Bool) {  }
  
  func removeCaptureLayer() {
    captureLayer?.removeFromSuperlayer()
  }
  
  func setVideoTimeLimit(_ value: String) {
    //videoCaptureLimitLabel.text = value
  }
  
  func setRecordingProgressBar(percentage: Double) {
//    videoCaptureLimitLabel.alpha = percentage > 0.001 ? 1.0 : 0.0
//    circleProgressBarView.alpha = percentage > 0.001 ? 1.0 : 0.0
//    circleProgressBarView.percent = CGFloat(percentage)
//    circleProgressBarView.setNeedsDisplay()
  }
  
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

fileprivate extension CameraPhotoCaptureViewController {
  func setupAppearance() {
    capturePhotoButton.layer.cornerRadius = capturePhotoButton.bounds.height * 0.5
    capturePhotoButton.clipsToBounds = true
//    
//    capturePhotoButtonBackgroundView.layer.cornerRadius = capturePhotoButtonBackgroundView.bounds.height * 0.5
//    capturePhotoButtonBackgroundView.clipsToBounds = true
//    
//    capturePhotoButtonBackgroundView.layer.borderWidth = 1.0
//    capturePhotoButtonBackgroundView.layer.borderColor = UIConstants.Colors.photoButtonBorder.cgColor
  }
}


//MARK:- DeviceOrientationNotificationsDelegateProtocol

extension CameraPhotoCaptureViewController: DeviceOrientationNotificationsDelegateProtocol {
  func deviceOrientationDidChangeTo(_ orientation: UIDeviceOrientation) {
    
  }
}
//MARK:- UIConstants

fileprivate enum UIConstants {
  enum BorderWidths {
    
    static let circleProgressBar: CGFloat = 3.0
    
  }
  
  enum Colors {
    static let videoButtonBorder = UIColor.lightGray
    static let photoButtonBorder = UIColor.white
    
    static let progressBarBackgroundCircle = UIColor.lightGray
    static let progressBarCircle = UIColor.red
    
    
  }
  
}
