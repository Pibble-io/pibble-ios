//
//  AVAssetOrientationExtension.swift
//  Pibble
//
//  Created by Kazakov Sergey on 13.07.2018.
//  Copyright © 2018 com.kazai. All rights reserved.
//

import Foundation
import AVFoundation

extension AVAsset {
  func videoOrientation() -> (orientation: AVCaptureVideoOrientation, device: AVCaptureDevice.Position, isPortrait: Bool) {
    var orientation: AVCaptureVideoOrientation = .portrait
    var device: AVCaptureDevice.Position = .unspecified
    var isPortrait: Bool = true
    
    let tracks :[AVAssetTrack] = self.tracks(withMediaType: AVMediaType.video)
    if let videoTrack = tracks.first {
      
      let t = videoTrack.preferredTransform
      
      if (t.a == 0 && t.b == 1.0 && t.d == 0) {
        orientation = .portrait
        
        if t.c == 1.0 {
          device = .front
        } else if t.c == -1.0 {
          device = .back
        }
      }
      else if (t.a == 0 && t.b == -1.0 && t.d == 0) {
        orientation = .portraitUpsideDown
        
        if t.c == -1.0 {
          device = .front
        } else if t.c == 1.0 {
          device = .back
        }
      }
      else if (t.a == 1.0 && t.b == 0 && t.c == 0) {
        orientation = .landscapeRight
        isPortrait = false
        
        if t.d == -1.0 {
          device = .front
        } else if t.d == 1.0 {
          device = .back
        }
      }
      else if (t.a == -1.0 && t.b == 0 && t.c == 0) {
        orientation = .landscapeLeft
        isPortrait = false
        
        if t.d == 1.0 {
          device = .front
        } else if t.d == -1.0 {
          device = .back
        }
      }
    }
    
    return (orientation, device, isPortrait)
  }
}
