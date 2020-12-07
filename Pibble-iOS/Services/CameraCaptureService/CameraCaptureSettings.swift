//
//  CameraCaptureSettings.swift
//  Pibble
//
//  Created by Kazakov Sergey on 11.07.2018.
//  Copyright © 2018 com.kazai. All rights reserved.
//

import AVFoundation

enum CameraCaptureSettings {
  case seconds15
  case seconds30
  case seconds60
  
  
  var minDuration: TimeInterval {
    return 1.0
  }
  
  var maxDurationTimeinterval: TimeInterval {
    switch self {
    case .seconds15:
      return 15.0
    case .seconds30:
      return 30.0
    case .seconds60:
      return 60.0
    }
  }
  
  var maxDuration: CMTime {
    switch self {
    case .seconds15:
      let seconds = 15.0
      let framesPerSecond = 30
      let timeScale = CMTimeScale(framesPerSecond)
      return CMTime(seconds: seconds, preferredTimescale: timeScale)
    case .seconds30:
      let seconds = 30.0
      let framesPerSecond = 30
      let timeScale = CMTimeScale(framesPerSecond)
      return CMTime(seconds: seconds, preferredTimescale: timeScale)
    case .seconds60:
      let seconds = 60.0
      let framesPerSecond = 30
      let timeScale = CMTimeScale(framesPerSecond)
      return CMTime(seconds: seconds, preferredTimescale: timeScale)
    }
  }
  
  var minFreeDiskSpaceLimit: Int64 {
    return 1024 * 1024
  }
}
