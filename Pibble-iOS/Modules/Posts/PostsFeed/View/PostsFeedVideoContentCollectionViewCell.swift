//
//  PostsFeedVideoContentCollectionViewCell.swift
//  Pibble
//
//  Created by Kazakov Sergey on 02.08.2018.
//  Copyright © 2018 com.kazai. All rights reserved.
//

import UIKit
import AVKit

typealias VideoPlayerStateHandler = (VideoPlayingState?) -> Void

typealias VideoPlayerStatusHandler = (AVPlayer) -> Void

enum VideoPlayingState {
  case paused(currentTime: TimeInterval, duration: TimeInterval, soundStatus: VideoSoundStatus)
  case playing(currentTime: TimeInterval, duration: TimeInterval, soundStatus: VideoSoundStatus)
}

enum VideoSoundStatus {
  case hasSound(isMuted: Bool)
  case noSound
}

class PostsFeedVideoContentCollectionViewCell: UICollectionViewCell, DequeueableCell {
  @IBOutlet weak var contentThumbnailImageView: UIImageView!

  func muteAction() -> VideoSoundStatus {
    videoLayer?.player?.setGloballyMuted(!AVPlayer.isGloballyMuted)
    
    let isAudioAvailable = videoLayer?.player?.isAudioAvailable ?? true
    let isMuted = videoLayer?.player?.isMuted ?? true
    let soundStatus: VideoSoundStatus = isAudioAvailable ? .hasSound(isMuted: isMuted) : .noSound
    
    return soundStatus
  }
  
  fileprivate var videoLayer: AVPlayerLayer?
  fileprivate var itemLayout: PostsFeed.ItemLayout =  PostsFeed.ItemLayout.defaultLayout()
  fileprivate var viewModel: PostsFeedVideoViewModelProtocol?
  
  fileprivate var playerStateHandler: VideoPlayerStatusHandler?
  fileprivate var playerStateObserver: NSKeyValueObservation?
  
  deinit {
    playerStateObserver = nil
  }
  
  func changePlayingState(_ playingStateHandler: @escaping VideoPlayerStateHandler) {
    guard let player = videoLayer?.player else {
      playingStateHandler(nil)
      return
    }
    
    if player.timeControlStatus == .playing {
      pause(playingStateHandler)
      return
    } else if player.timeControlStatus == .paused {
      play(playingStateHandler)
      return
    }
    
    playingStateHandler(nil)
  }
  
  func play(_ playingStateHandler: @escaping VideoPlayerStateHandler) {
    guard let player = videoLayer?.player else {
      playingStateHandler(nil)
      return
    }
    
    guard case AVPlayer.Status.readyToPlay = player.status else {
      self.playerStateHandler = { [weak self] in
        $0.setGloballyMuted(true)
        $0.setCurrentlyPlaying()
        let playingState = self?.processPlayerPlayingStatus(player: $0, playing: true)
        playingStateHandler(playingState)
      }
      
      playingStateHandler(nil)
      return
    }
    
    self.playerStateHandler = nil
    
    player.setGloballyMuted(true)
    //    videoLayer?.player?.seek(to: kCMTimeZero + CMTime(seconds: 0.001, preferredTimescale: CMTimeScale(30)))
    player.setCurrentlyPlaying()
    let playingState = processPlayerPlayingStatus(player: player, playing: true)
    playingStateHandler(playingState)
  }
  
  func pause(_ playerStateHandler: @escaping VideoPlayerStateHandler) {
    guard let player = videoLayer?.player else {
      playerStateHandler(nil)
      return
    }
 
    self.playerStateHandler = nil
    player.setGloballyMuted(true)
    player.pause()
    let status = processPlayerPlayingStatus(player: player, playing: false)
    playerStateHandler(status)
  }
  
  fileprivate func processPlayerPlayingStatus(player: AVPlayer, playing: Bool) -> VideoPlayingState? {
    guard let duration = player.currentItem?.duration.seconds,
      let currentTime = player.currentItem?.currentTime().seconds else {
        return nil
    }
    
    let isAudioAvailable = player.isAudioAvailable ?? true
    let isMuted = player.isMuted
    let soundStatus: VideoSoundStatus = isAudioAvailable ? .hasSound(isMuted: isMuted) : .noSound
    
    return playing ?
        .playing(currentTime: currentTime, duration: duration, soundStatus: soundStatus):
        .paused(currentTime: currentTime, duration: duration, soundStatus: soundStatus)
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
  }
  
  func setViewModel(_ vm:
    PostsFeedVideoViewModelProtocol, layout: PostsFeed.ItemLayout) {
    viewModel = vm
//    muteSoundImageView.alpha = 0.0
    contentThumbnailImageView.image = nil
    contentThumbnailImageView.setCachedImageOrDownload(vm.thumbnailImageUrlString)
    
    playerStateHandler = nil
    let newVideoLayer = AVPlayerLayer(urlString: vm.urlString)
    
    videoLayer?.removeFromSuperlayer()
    videoLayer = newVideoLayer
    
    playerStateObserver = videoLayer?.player?.observe(\AVPlayer.status) { [weak self] (object, observedChange) in
      guard let strongSelf = self else {
        return
      }
      strongSelf.playerStateHandler?(object)
    }
    itemLayout = layout
    guard let video = videoLayer else {
      return
    }
    
    video.frame.size = itemLayout.size
    
    videoLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
    contentThumbnailImageView.layer.addSublayer(video)
  }
}


