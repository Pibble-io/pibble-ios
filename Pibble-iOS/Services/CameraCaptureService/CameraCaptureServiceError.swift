//
//  CameraCaptureServiceError.swift
//  Pibble
//
//  Created by Kazakov Sergey on 16.07.2018.
//  Copyright © 2018 com.kazai. All rights reserved.
//

import Foundation

enum CameraCaptureServiceError: PibbleErrorProtocol {
  case captureSessionAlreadyRunning
  case captureServiceIsAlreadyPreparing
  case captureSessionIsMissing
  case captureSessionIsNotRunning
  
  case inputsAreInvalid
  case invalidOperation
  case noCamerasAvailable
  case unknown
  case accessDenied
  case videoRecordingItemsManagerIsMissing
  case videoRecordingItemCreationFailure
  case videoIsTooShort
  case videoLengthLimitationReached
  case videoNotRecorded
  
  case mergingVideoFailed(Error)
  case exportVideoSessionFailed
  
  var description: String {
    switch self {
    case .accessDenied:
      return ErrorStrings.CameraCaptureServiceError.accessDenied.localize()
    case .captureSessionAlreadyRunning:
      return ErrorStrings.CameraCaptureServiceError.captureSessionAlreadyRunning.localize()
    case .captureSessionIsMissing:
      return ErrorStrings.CameraCaptureServiceError.captureSessionIsMissing.localize()
    case .inputsAreInvalid:
      return ErrorStrings.CameraCaptureServiceError.inputsAreInvalid.localize()
    case .invalidOperation:
      return ErrorStrings.CameraCaptureServiceError.invalidOperation.localize()
    case .noCamerasAvailable:
      return ErrorStrings.CameraCaptureServiceError.noCamerasAvailable.localize()
    case .unknown:
      return ErrorStrings.CameraCaptureServiceError.unknown.localize()
    case .captureSessionIsNotRunning:
      return ErrorStrings.CameraCaptureServiceError.captureSessionIsNotRunning.localize()
    case .captureServiceIsAlreadyPreparing:
      return ErrorStrings.CameraCaptureServiceError.captureServiceIsAlreadyPreparing.localize()
    case .videoRecordingItemsManagerIsMissing:
      return ErrorStrings.CameraCaptureServiceError.videoRecordingItemsManagerIsMissing.localize()
    case .videoRecordingItemCreationFailure:
      return ErrorStrings.CameraCaptureServiceError.videoRecordingItemCreationFailure.localize()
    case .videoIsTooShort:
      return ErrorStrings.CameraCaptureServiceError.videoIsTooShort.localize()
    case .videoNotRecorded:
      return ErrorStrings.CameraCaptureServiceError.videoNotRecorded.localize()
    case .videoLengthLimitationReached:
      return ErrorStrings.CameraCaptureServiceError.videoLengthLimitationReached.localize()
    case .mergingVideoFailed(let error):
      return ErrorStrings.CameraCaptureServiceError.mergingVideoFailed.localize(value: error.localizedDescription)
    case .exportVideoSessionFailed:
      return ErrorStrings.CameraCaptureServiceError.exportVideoSessionFailed.localize()
    }
  }
}

extension ErrorStrings {
  enum CameraCaptureServiceError: String, LocalizedStringKeyProtocol {
    case accessDenied = "Please, give the app access to your Camera and Microphone in your Settings"
    case captureSessionAlreadyRunning = "Capture session already running"
    case captureSessionIsMissing = "Capture session is missing"
    case inputsAreInvalid = "Inputs are invalid"
    case invalidOperation = "Invalid operation"
    case noCamerasAvailable = "No cameras available"
    case unknown = "CameraCaptureService unknown error"
    case captureSessionIsNotRunning = "Capture session is not running"
    case captureServiceIsAlreadyPreparing = "Capture service is already preparing"
    case videoRecordingItemsManagerIsMissing = "Video recording items manager is missing"
    case videoRecordingItemCreationFailure = "Video recording item creation failure"
    case videoIsTooShort = "Video is too short"
    case videoNotRecorded = "Video is not recorded"
    case videoLengthLimitationReached = "Video length limitation reached"
    case mergingVideoFailed = "Merging video failed with =  %"
    case exportVideoSessionFailed = "Export video session failed"
  }
}
