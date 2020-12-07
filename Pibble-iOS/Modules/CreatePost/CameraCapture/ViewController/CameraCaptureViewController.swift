//
//  CameraCaptureViewController.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 05.07.2018.
//Copyright © 2018 com.kazai. All rights reserved.
//

import UIKit

//MARK: CameraCaptureView Class
final class CameraCaptureViewController: ViewController {
  //MARK:- IBOutlets
  
  @IBOutlet weak var buttonsBackgroundView: UIView!
  
  @IBOutlet weak var captureView: UIView!
  @IBOutlet weak var capturePhotoButton: UIButton!
  @IBOutlet weak var capturePhotoButtonBackgroundView: UIView!
 
  @IBOutlet weak var swapCameraButton: UIButton!
  @IBOutlet weak var captureVideoButton: UIButton!
  @IBOutlet weak var captureVideoButtonBackgroundView: UIView!
  @IBOutlet weak var videoCaptureLimitLabel: UILabel!
  @IBOutlet weak var circleProgressBarView: CircleProgressBarView!
  fileprivate var captureLayer: CALayer?
  
  
  //MARK:- IBActions
  
  @IBAction func hideAction(_ sender: Any) {
    presenter.handleHideAction()
  }
  
  @IBAction func captureVideoStartAction(_ sender: Any) {
    presenter.handleCaptureVideoStartAction()
  }
  
  @IBAction func captureVideoEndAction(_ sender: Any) {
    presenter.handleCaptureVideoEndAction()
  }
  
  @IBAction func capturePhotoAction(_ sender: Any) {
    presenter.handleCapturePhotoAction()
  }
  
  @IBAction func switchCameraAction(_ sender: Any) {
    presenter.handleSwitchCameraAction()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupAppearance()
  }
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
  }
  
  override var prefersStatusBarHidden: Bool {
    return true
  }
}

//MARK: - CameraCaptureView API
extension CameraCaptureViewController: CameraCaptureViewControllerApi {
  func presentVideoTimelimitReachedAlert() {
     
  }
  
  func setCurrentTimerValue(_ value: String, isActive: Bool) {
    
  }
 
  func setMinVideoLengthIndicator(percentage: Double) { }
  
  func setProgressBarRecordingState(_ recording: Bool, animated: Bool) { }  
  func setCurrentVideoLength(_ value: String) { }
  func setButtonsRecordingState(_ recording: Bool, animated: Bool) { }
  
  func removeCaptureLayer() {
     captureLayer?.removeFromSuperlayer()
  }
  
  func setVideoTimeLimit(_ value: String) {
    videoCaptureLimitLabel.text = value
  }
  
  func setRecordingProgressBar(percentage: Double) {
    videoCaptureLimitLabel.alpha = percentage > 0.001 ? 1.0 : 0.0
    circleProgressBarView.alpha = percentage > 0.001 ? 1.0 : 0.0
    circleProgressBarView.percent = CGFloat(percentage)
    circleProgressBarView.setNeedsDisplay()
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

fileprivate extension CameraCaptureViewController {
  func setupAppearance() {
    capturePhotoButton.layer.cornerRadius = capturePhotoButton.bounds.height * 0.5
    capturePhotoButton.clipsToBounds = true
    
    capturePhotoButtonBackgroundView.layer.cornerRadius = capturePhotoButtonBackgroundView.bounds.height * 0.5
    capturePhotoButtonBackgroundView.clipsToBounds = true
    
    capturePhotoButtonBackgroundView.layer.borderWidth = 1.0
    capturePhotoButtonBackgroundView.layer.borderColor = UIConstants.Colors.photoButtonBorder.cgColor
    
    captureVideoButton.layer.cornerRadius = captureVideoButton.bounds.height * 0.5
    captureVideoButton.clipsToBounds = true
    
    captureVideoButton.layer.borderWidth = 1.0
    captureVideoButton.layer.borderColor = UIConstants.Colors.videoButtonBorder.cgColor
    
    captureVideoButtonBackgroundView.layer.cornerRadius = captureVideoButtonBackgroundView.bounds.height * 0.5
    captureVideoButtonBackgroundView.clipsToBounds = true
    
    circleProgressBarView.clipsToBounds = false
    circleProgressBarView.progressBarColor = UIConstants.Colors.progressBarCircle
    circleProgressBarView.progressBarWidth = UIConstants.BorderWidths.circleProgressBar
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
