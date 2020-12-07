//
//  VideoPlayerServiceProtocol.swift
//  Pibble
//
//  Created by Kazakov Sergey on 16.08.2018.
//  Copyright © 2018 com.kazai. All rights reserved.
//

import Foundation
import AVKit

protocol VideoPlayerServiceProtocol {
  var state: VideoPlayerServiceState { get }
  func prepare()
  func cancel()
  func pause()
  
  var isFailed: Bool { get }
  var isPlaying: Bool { get } 
  
  var playerInstance: AVPlayer { get }
}
