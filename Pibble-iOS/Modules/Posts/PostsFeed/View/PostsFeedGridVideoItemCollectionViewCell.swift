//
//  PostsFeedGridVideoItemCollectionViewCell.swift
//  Pibble
//
//  Created by Kazakov Sergey on 26.12.2018.
//  Copyright © 2018 com.kazai. All rights reserved.
//

import UIKit
import AVKit

class PostsFeedGridVideoItemCollectionViewCell: UICollectionViewCell, DequeueableCell {
  @IBOutlet weak var contentThumbnailImageView: UIImageView!
  @IBOutlet weak var muteSoundImageView: UIImageView!
  @IBOutlet weak var muteButton: UIButton!
  
  @IBAction func muteAction(_ sender: Any) {
    videoLayer?.player?.setGloballyMuted(!AVPlayer.isGloballyMuted)
    
    let isAudioAvailable = videoLayer?.player?.isAudioAvailable ?? true
    let isMuted = videoLayer?.player?.isMuted ?? true
    let soundStatus: VideoSoundStatus = isAudioAvailable ? .hasSound(isMuted: isMuted) : .noSound
    
    switch soundStatus {
    case .hasSound(let isMuted):
      muteSoundImageView.image = isMuted ?
        UIImage(imageLiteralResourceName: "PostsFeed-MuteSound") :
        UIImage(imageLiteralResourceName: "PostsFeed-MuteSound-active")
    case .noSound:
      muteSoundImageView.image = UIImage(imageLiteralResourceName: "PostsFeed-NoSound")
    }
    
    muteSoundImageView.alpha = 1.0
    UIView.animate(withDuration: 1.0) { [weak self] in
      self?.muteSoundImageView.alpha = 0.0
    }
  }
  
  @IBAction func playStateChangeAction(_ sender: Any) {
    changePlayingState()
  }
  
  fileprivate var videoLayer: AVPlayerLayer?
  fileprivate var itemLayout: PostsFeed.ItemLayout =  PostsFeed.ItemLayout.defaultLayout()
  
  func changePlayingState() {
    guard let player = videoLayer?.player else {
      return
    }
    
    if player.timeControlStatus == .playing {
      pause()
    } else if player.timeControlStatus == .paused {
      play()
    }
  }
  
  func pause() {
    DispatchQueue.main.async {[weak self] in
      self?.videoLayer?.player?.pause()
    }
  }
  
  func play() {
    videoLayer?.player?.setGloballyMuted(AVPlayer.isGloballyMuted)
    //    videoLayer?.player?.seek(to: kCMTimeZero + CMTime(seconds: 0.001, preferredTimescale: CMTimeScale(30)))
    
    DispatchQueue.main.async {[weak self] in
      self?.videoLayer?.player?.setCurrentlyPlaying()
    }
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
    muteSoundImageView.setCornersToCircleByHeight()
  }
  
  func setViewModel(_ vm:
    PostsFeedVideoViewModelProtocol, layout: PostsFeed.ItemLayout) {
    muteSoundImageView.alpha = 0.0
    contentThumbnailImageView.image = nil
    contentThumbnailImageView.setCachedImageOrDownload(vm.thumbnailImageUrlString)
    
    let newVideoLayer = AVPlayerLayer(urlString: vm.urlString)
    
    videoLayer?.removeFromSuperlayer()
    videoLayer = newVideoLayer
    itemLayout = layout
    guard let video = videoLayer else {
      return
    }
    
    video.frame.size = itemLayout.size
    
    videoLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
    contentThumbnailImageView.layer.addSublayer(video)
  }
}
