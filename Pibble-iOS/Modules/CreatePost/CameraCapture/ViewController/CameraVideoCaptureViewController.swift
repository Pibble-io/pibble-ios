//
//  CameraVideoCaptureViewController.swift
//  Pibble
//
//  Created by Kazakov Sergey on 09.07.2018.
//  Copyright © 2018 com.kazai. All rights reserved.
//

import AVFoundation
import UIKit

final class CameraVideoCaptureViewController: ViewController {
  //MARK:- IBOutlets
  
  @IBOutlet weak var buttonsBackgroundView: UIView!
  
  @IBOutlet weak var captureView: UIView!
  @IBOutlet weak var captureVideoButton: UIButton!
  @IBOutlet weak var captureVideoButtonBackgroundView: UIView!
  @IBOutlet weak var captureVideoButtonBackgroundDimView: UIView!
  
  @IBOutlet weak var swapCameraButton: UIButton!
  
  @IBOutlet weak var progressBarContainerView: UIView!
  @IBOutlet weak var progressBarBackgroundView: UIView!
  
  @IBOutlet weak var progressBarView: UIView!
  @IBOutlet weak var currentVideoLengthLabel: UILabel!
  @IBOutlet weak var maxVideoLengthLabel: UILabel!
  @IBOutlet weak var progressBarViewWidthConstraint: NSLayoutConstraint!
  @IBOutlet weak var minVideoLengthView: UIView!
  
  @IBOutlet weak var minVideoLengthViewTrailingConstraint: NSLayoutConstraint!
  //MARK:- IBActions
  
  @IBAction func finishAction(_ sender: Any) {
    presenter.handleFinishAction()
  }
  
  @IBAction func hideAction(_ sender: Any) {
    presenter.handleHideAction()
  }
  
  @IBAction func captureVideoStartAction(_ sender: Any) {
    presenter.handleCaptureVideoStartAction()
  }
  
  @IBAction func captureVideoEndAction(_ sender: Any) {
    presenter.handleCaptureVideoEndAction()
  }
  
  @IBAction func switchCameraAction(_ sender: Any) {
    presenter.handleSwitchCameraAction()
  }
  
  //MARK:- Private properties
  
  fileprivate var captureLayer: CALayer?
  
  //MARK:- Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupAppearance()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    subscribeDeviceOrientationNotications()
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

fileprivate extension CameraVideoCaptureViewController {
  var presenter: CameraCapturePresenterApi {
    return _presenter as! CameraCapturePresenterApi
  }
}

extension CameraVideoCaptureViewController: CameraCaptureViewControllerApi {
  func presentVideoTimelimitReachedAlert() {
    let alertController = UIAlertController(title: nil, message: CameraCapture.Strings.videoTimelimitReachedAlertMessage.localize(), safelyPreferredStyle: .alert)

    alertController.view.tintColor = UIColor.bluePibble
    
    let next = UIAlertAction(title: CameraCapture.Strings.videoTimelimitReachedAlertActionTitle.localize(), style: .default) { [weak self] (action) in
      self?.presenter.handleFinishAction()
    }

    alertController.addAction(next)
    present(alertController, animated: true, completion: nil)
    alertController.view.tintColor = UIColor.bluePibble
  }
  
  func setCurrentTimerValue(_ value: String, isActive: Bool) {
    
  }
  
  func setMinVideoLengthIndicator(percentage: Double) {
    minVideoLengthViewTrailingConstraint.constant =  progressBarBackgroundView.bounds.width * CGFloat(percentage) * 0.01
    view.layoutIfNeeded()
  }
  
  func setProgressBarRecordingState(_ recording: Bool, animated: Bool) {
    guard animated else {
      setProgressBarPresentation(!recording)
      return
    }
    
    UIView.animate(withDuration: 0.3) { [weak self] in
      self?.setProgressBarPresentation(!recording)
    }
  }
  
  func setCurrentVideoLength(_ value: String) {
    currentVideoLengthLabel.text = value
  }
  
  func setButtonsRecordingState(_ recording: Bool, animated: Bool) {
    guard animated else {
      setCaptureVideoButtonPresentation(recording)
      return
    }
    
    UIView.animate(withDuration: 0.3) { [weak self] in
      self?.setCaptureVideoButtonPresentation(recording)
    }
  }
  
  func removeCaptureLayer() {
    captureLayer?.removeFromSuperlayer()
  }
  
  func setVideoTimeLimit(_ value: String) {
    maxVideoLengthLabel.text = value
  }
  
  func setRecordingProgressBar(percentage: Double) {
    progressBarViewWidthConstraint.constant = progressBarBackgroundView.bounds.width * CGFloat(percentage) * 0.01
    UIView.animate(withDuration: 0.15) { [weak self] in
      self?.progressBarContainerView.layoutIfNeeded()
    }
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

extension CameraVideoCaptureViewController {
  fileprivate func setProgressBarPresentation(_ hidden: Bool) {
    let alpha: CGFloat = hidden ? 0.0 : 1.0
    progressBarContainerView.alpha = alpha
  }
  
  fileprivate func setCaptureVideoButtonPresentation(_ recording: Bool) {
    let scale = recording ? UIConstants.Constraints.videoCaptureBackgroundMaxScale :
      UIConstants.Constraints.videoCaptureBackgroundMinScale
    
    let transform = CGAffineTransform(scaleX: scale, y: scale)
    captureVideoButtonBackgroundView.transform = transform
  }
  
  fileprivate func setupAppearance() {
    captureVideoButton.layer.cornerRadius = captureVideoButton.bounds.height * 0.5
    captureVideoButton.clipsToBounds = true
    captureVideoButton.layer.borderWidth = 1.5
    captureVideoButton.layer.borderColor = UIConstants.Colors.videoButtonBorder.cgColor
    captureVideoButtonBackgroundDimView.layer.cornerRadius = captureVideoButtonBackgroundDimView.bounds.height * 0.5
    captureVideoButtonBackgroundView.layer.cornerRadius = captureVideoButtonBackgroundView.bounds.height * 0.5
    captureVideoButtonBackgroundView.clipsToBounds = true
  }
}

//MARK:- DeviceOrientationNotificationsDelegateProtocol

extension CameraVideoCaptureViewController: DeviceOrientationNotificationsDelegateProtocol {
  func deviceOrientationDidChangeTo(_ orientation: UIDeviceOrientation) {
     
  }
}

//MARK:- UIConstants

fileprivate enum UIConstants {
  enum BorderWidths {
    static let circleProgressBar: CGFloat = 3.0
  }
  
  enum Constraints {
    static let videoCaptureBackgroundMaxScale: CGFloat = 1.8
    static let videoCaptureBackgroundMinScale: CGFloat = 1.0
  }
  
  enum Colors {
    static let videoButtonBorder = UIColor.white
    
    static let progressBarBackgroundCircle = UIColor.lightGray
    static let progressBarCircle = UIColor.red
  }
}

extension CameraCapture {
  enum Strings: String, LocalizedStringKeyProtocol {
    case videoTimelimitReachedAlertMessage = "You've reached the time limit for video"
    case videoTimelimitReachedAlertActionTitle = "Next"
  }
}
