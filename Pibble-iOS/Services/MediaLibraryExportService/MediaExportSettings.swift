//
//  MediaExportSettings.swift
//  Pibble
//
//  Created by Kazakov Sergey on 18.08.2018.
//  Copyright © 2018 com.kazai. All rights reserved.
//

import Foundation
import UIKit
import AVKit
import AVFoundation


struct MediaExportSettings {
  enum ImageFormat {
    case landscape
    case portrait
    case square
  }

  static let defaultExportSettings = MediaExportSettings(imageWidth: 1080, imageCompresion: 0.5)
  
  fileprivate let imageWidth: CGFloat
  let userpicImageSize = CGSize(width: 161, height: 161)
  
  let imageOriginalCompresion: CGFloat = 1.0
  let imageCompresion: CGFloat
  let rawVideoFileExportPreset: String = AVAssetExportPreset960x540
  let recordedVideoFileExportPreset: String = AVAssetExportPreset960x540
  let videoTargetSize: CGSize = CGSize(width: 640, height: 640)
  let videoTargetExportPreset: String = AVAssetExportPresetHighestQuality
  
  let outputFileType: AVFileType = .mp4
  let shouldOptimizeForNetworkUse = true
  
  let imageMaxWidth: CGFloat = 1080
  let imageMinWidth: CGFloat = 320
  let imageMaxHeight: CGFloat = 1350
  let imageMinHeight: CGFloat = 565
  
  let videoMinSizes = CGSize(width: 320, height: 336)
  let videoMaxSizes = CGSize(width: 640, height: 800)
  
  let imageMinLandscapeAspectRatio: CGFloat = 1.0 / 1.91 // height/width
  let imageMaxPortraitAspectRatio: CGFloat = 5.0 / 4.0    // height/width
  
  let userPicImageMinLandscapeAspectRatio: CGFloat = 1.0 // height/width
  let userPicImageMaxPortraitAspectRatio: CGFloat = 1.0  // height/width
  
  
  let videoMinLandscapeAspectRatio: CGFloat = 1.0 / 1.91 // height/width
  let videoMaxPortraitAspectRatio: CGFloat = 5.0 / 4.0    // height/width
  
  let cameraCaptureSettings = CameraCaptureSettings.seconds60

  func imageSizeFor(_ format: ImageFormat) -> CGSize {
    switch format {
    case .landscape:
      return CGSize(width: 1080, height: 608)
    case .portrait:
      return CGSize(width: 1080, height: 1350)
    case .square:
      return CGSize(width: 1080, height: 1080)
    }
  }
}
