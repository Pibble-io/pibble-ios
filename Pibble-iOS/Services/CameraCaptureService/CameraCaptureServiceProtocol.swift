//
//  CameraCaptureServiceProtocol.swift
//  Pibble
//
//  Created by Kazakov Sergey on 05.07.2018.
//  Copyright © 2018 com.kazai. All rights reserved.
//

import UIKit
import AVFoundation

protocol CameraCaptureScanQRCodeDelegateProtocol: class {
  func didCaptureQRCode(_ code: String, in bounds: CGRect)
}

protocol CameraCaptureServiceProtocol: class {
  func prepare(completionHandler: @escaping (Error?) -> Void)
  
  func stopCaptureSession()
  func startCaptureSession(completionHandler: @escaping (Error?) -> Void)
  
  func captureImage(completion: @escaping (UIImage?, Error?) -> Void)
  
  func getPreviewLayer() throws -> CALayer?
  
  func switchCameras() throws
  
  var maxDuration: TimeInterval { get }
  var minDuration: TimeInterval { get }
  
  var scanQRCodeDelegate: CameraCaptureScanQRCodeDelegateProtocol? { get set }
  
  func startRecording(_ complete: @escaping (Error?) -> Void)
  func stopRecording()
  func exportRecordedVideo(_ complete: @escaping ResultCompleteHandler<URL, CameraCaptureServiceError>)
  var currentVideoRecordingSessionDuration: TimeInterval { get }
}
