//
//  InterfaceOrientationExtension.swift
//  Pibble
//
//  Created by Kazakov Sergey on 12.07.2018.
//  Copyright © 2018 com.kazai. All rights reserved.
//

import UIKit
import AVFoundation

extension UIDeviceOrientation {
  var captureVideoOrientation: AVCaptureVideoOrientation {
    switch self {
    case .portrait:
      return .portrait
    case .portraitUpsideDown:
      return .portraitUpsideDown
    case .landscapeLeft:
      return .landscapeRight
    case .landscapeRight:
      return .landscapeLeft
    case .faceDown, .faceUp, .unknown:
      return .portrait
    }
  }
}


